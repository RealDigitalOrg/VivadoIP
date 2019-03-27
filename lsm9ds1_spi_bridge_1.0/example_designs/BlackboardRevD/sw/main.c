/*********************************************************************************
 * File: main.c
 * Author: Tinghui Wang
 *
 * Copyright @ 2019 RealDigital.org
 *
 * Description:
 *   Example test for LSM9DS1 iNEMO inertial module. 
 *
 * History:
 *   11/13/17: Created
 *
 * License: BSD 3-Clause
 *
 * Redistribution and use in source and binary forms, with or without 
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this 
 *    list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice, 
 *    this list of conditions and the following disclaimer in the documentation 
 *    and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its contributors 
 *    may be used to endorse or promote products derived from this software 
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE 
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 *********************************************************************************/

#include "xparameters.h"
#include <xil_printf.h>
#include <xspips.h>
#include <xgpiops.h>
#include "lsm9ds1_regs.h"

#define SPI_DEVICE_ID XPAR_XSPIPS_0_DEVICE_ID
#define GPIOPS_DEVICE_ID XPAR_XGPIOPS_0_DEVICE_ID

static XSpiPs spiInst;
static XGpioPs gpioInst;
uint8_t spiSendBuffer[256];
uint8_t spiRecvBuffer[256];

void Spi_ReadBytes(uint8_t address, uint8_t *buffer, uint8_t length) {
	spiSendBuffer[0] = 0x80 | (address & 0x7F);
	XSpiPs_PolledTransfer(&spiInst, spiSendBuffer, spiRecvBuffer, length);
	for(int i = 0; i < length; i++) {
		buffer[i] = spiRecvBuffer[i + 1];
	}
}

void Spi_SendBytes(uint8_t address, uint8_t *buffer, uint8_t length) {
	spiSendBuffer[0] = 0x80 | (address & 0x7F);
	for(int i = 0; i < length; i++) {
		spiSendBuffer[i + 1] = buffer[i];
	}
	XSpiPs_PolledTransfer(&spiInst, spiSendBuffer, spiRecvBuffer, length);
}

uint8_t Spi_ReadByte(uint8_t address) {
	spiSendBuffer[0] = 0x80 | address;
	spiSendBuffer[1] = 0x00;
	XSpiPs_PolledTransfer(&spiInst, spiSendBuffer, spiRecvBuffer, 2);
	return spiRecvBuffer[1];
}

void Spi_SendByte(uint8_t address, uint8_t value) {
	spiSendBuffer[0] = 0x80 | address;
	spiSendBuffer[1] = value;
	XSpiPs_PolledTransfer(&spiInst, spiSendBuffer, spiRecvBuffer, 2);
}

void Spi_Init() {
	XSpiPs_Config *spiConfig;
	spiConfig = XSpiPs_LookupConfig(SPI_DEVICE_ID);
	XSpiPs_CfgInitialize(&spiInst, spiConfig, spiConfig->BaseAddress);
	XSpiPs_SetOptions(&spiInst, XSPIPS_MASTER_OPTION | XSPIPS_CLK_ACTIVE_LOW_OPTION | XSPIPS_CLK_PHASE_1_OPTION | XSPIPS_FORCE_SSELECT_OPTION);
	XSpiPs_SetClkPrescaler(&spiInst, XSPIPS_CLK_PRESCALE_128);
}

void Spi_SelectAG() {
	XSpiPs_SetSlaveSelect(&spiInst, 0);
}

void Spi_SelectM() {
	XSpiPs_SetSlaveSelect(&spiInst, 1);
}

void Gpio_SetAGDen(uint8_t value) {
	XGpioPs_WritePin(&gpioInst, 54, value);
}

void Gpio_Init() {
	XGpioPs_Config *gpioConfig;

	gpioConfig = XGpioPs_LookupConfig(GPIOPS_DEVICE_ID);
	XGpioPs_CfgInitialize(&gpioInst, gpioConfig, gpioConfig->BaseAddr);
	XGpioPs_SetDirectionPin(&gpioInst, 54, 1);
	XGpioPs_SetOutputEnablePin(&gpioInst, 54, 1);
}

void XLG_Test() {
	uint8_t regval;
	Spi_SelectAG();
	regval = Spi_ReadByte(WHO_AM_I_XLG);
	if(regval == WHO_AM_I_XLG_VAL) {
		xil_printf("[PASS] LSM9DS1 Accelerometer/Gyroscope WhoAmI Register Test.\r\n");
	} else {
		xil_printf("[FAIL] LSM9DS1 Accelerometer/Gyroscope WhoAmI Register Test.\r\n");
		xil_printf("\tError: Revceived 0x%x instead of 0x%x.\r\n", regval, WHO_AM_I_XLG_VAL);
	}
	Spi_SelectM();
	regval = Spi_ReadByte(WHO_AM_I_M);
	if(regval == WHO_AM_I_M_VAL) {
		xil_printf("[PASS] LSM9DS1 Magnetic Sensor WhoAmI Register Test.\r\n");
	} else {
		xil_printf("[FAIL] LSM9DS1  Magnetic Sensor WhoAmI Register Test.\r\n");
		xil_printf("\tError: Revceived 0x%x instead of 0x%x.\r\n", regval, WHO_AM_I_M_VAL);
	}
}

int main() {
	xil_printf("LSM9DS1 Example Design\r\n");
	Gpio_Init();
	Spi_Init();
	XLG_Test();
	while(1) {
	}
}

