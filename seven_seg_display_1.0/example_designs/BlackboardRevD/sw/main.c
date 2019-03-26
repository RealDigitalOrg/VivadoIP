/*********************************************************************************
 * File: main.c
 * Author: Tinghui Wang
 *
 * Copyright @ 2019 RealDigital.org
 *
 * Description:
 *   Example test for seven segment display controller. 
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
#include <xil_types.h>
#include <xil_printf.h>
#include <xil_io.h>
#include <stdio.h>
#include <stdlib.h>

#define SSD_MODE_REG XPAR_SEVEN_SEG_DISPLAY_S_AXI_BASEADDR
#define SSD_EN_REG XPAR_SEVEN_SEG_DISPLAY_S_AXI_BASEADDR
#define SSD_DIGITS_BASE (XPAR_SEVEN_SEG_DISPLAY_S_AXI_BASEADDR + 4)
#define MAX_DIGIT_BUF 32

void help() {
	xil_printf("\r\nMenu\r\n");
	xil_printf("s - Enter segment mode\r\n");
	xil_printf("d - Enter digit mode\r\n");
	xil_printf("i - Enter the value of each digit\r\n");
}

uint8_t readDigit() {
	char buf[MAX_DIGIT_BUF];
	char tmp = '\0';
	int i = 0;
	tmp = getchar();
	while(tmp != '\n' && tmp != '\r' && i < MAX_DIGIT_BUF - 1) {
		xil_printf("%c", tmp);
		buf[i] = tmp;
		i++;
		tmp = getchar();
	}
	buf[i] = '\0';
	xil_printf("%c", tmp);
	if(tmp != '\n') {
		xil_printf("\r\n");
	}
	return (uint8_t) atoi(buf);
}

int main() {
	char cmd = ' ';
	uint8_t digit = 0;
	setvbuf(stdin, NULL, _IONBF, 0);
	xil_printf("Seven Segment Display Example Design\r\n");
	Xil_Out8(SSD_EN_REG, 0x01);
	Xil_Out8(SSD_DIGITS_BASE, 0xA);
	Xil_Out8(SSD_DIGITS_BASE+1, 0xF);
	Xil_Out8(SSD_DIGITS_BASE+2, 0xC);
	Xil_Out8(SSD_DIGITS_BASE+3, 0xB);
	help();
	while(1) {
		help();
		cmd = getchar();
		xil_printf("%c\r\n", cmd);
		switch(cmd) {
		case 's':
			Xil_Out8(SSD_MODE_REG, Xil_In8(SSD_MODE_REG) | 0x02);
			break;
		case 'd':
			Xil_Out8(SSD_MODE_REG, Xil_In8(SSD_MODE_REG) & ~0x02);
			break;
		case 'i':
			for(int i = 0; i < 4; i++) {
				xil_printf("Digit %d: ", i);
				digit = readDigit();
				Xil_Out8(SSD_DIGITS_BASE + i, digit);
			}
			break;
		default:
			xil_printf("Command %c is invalid.\r\n");
			break;
		}
	}
}
