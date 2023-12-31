#ifndef __INCLUDES_H__
#define __INCLUDES_H__

#include "delay.h"
#define ADDR_WR 0x90
#define ADDR_RD 0x91
#define I2C_SDA_PORT  PORTC.1
#define I2C_SCL_PORT  PORTC.0
#define I2C_SDA_PIN  PINC.1
#define I2C_SCL_PIN  PINC.0
//#define I2C_IN DDRC=0x00
//#define I2C_OUT DDRC=0xff
void I2C_SCL_IN(void);
void I2C_SDA_IN(void);
void I2C_SCL_OUT(void);
void I2C_SDA_OUT(void);

#define LED_WHITE PORTA.4 //补光灯
#define LED_YELLOW PORTA.3 //补温灯
#define FAN  PORTA.6
#define RELAY  PORTD.0

#define KEY_SET PINA.0
#define KEY_ADD PIND.6
#define KEY_SUB PIND.7

#define BIT7 0x80
#define BIT6 0x40
#define BIT5 0x20
#define BIT4 0x10
#define BIT3 0x08
#define BIT2 0x04
#define BIT1 0x02
#define BIT0 0x01

#define uchar unsigned char
#define bit unsigned char

#define LCD_OP_PORT PORTB
#define LCD_IP_PORT PINB
#define LCD_DIR_PORT DDRB
#define LCD_EN  (1 << 2)     //引脚定义
#define LCD_RS (1 << 0)
#define LCD_RW (1 << 1)
//#define lcd_set_e()  (LCD_OP_PORT |= LCD_EN)   //置位与清零
#define lcd_set_rs() (LCD_OP_PORT |= LCD_RS)
#define lcd_set_rw() (LCD_OP_PORT |= LCD_RW)
//#define lcd_clear_e()  (LCD_OP_PORT &= ~LCD_EN)
#define lcd_clear_rs() (LCD_OP_PORT &= ~LCD_RS)
#define lcd_clear_rw() (LCD_OP_PORT &= ~LCD_RW)
#define LCD_ON 0x0C
#define LCD_CURS_ON 0x0D
#define LCD_OFF 0x08
#define LCD_HOME 0x02
#define LCD_CLEAR 0x01
#define LCD_NEW_LINE 0xC0
#define LCD_FUNCTION_SET 0x28
#define LCD_MODE_SET 0x06

#define DQ_DIR_IN()    DDRB &= ~(1<<3)      //PB4引脚设置为输入
#define DQ_DIR_OUT()   DDRB |= (1<<3)		//设置为输出
#define DQ_DATA        ((PINB&(1<<3))>>3)		//引脚上的输入的电平
#define DQ_SET()       PORTB |= (1<<3)			//输出高电平
#define DQ_CLEAR()     PORTB &= ~(1<<3)	//输出低电平


void LCD_INIT(void);
void LCD_Busy(void);
void Init_LCD(void);
void LCD_WriteControl (unsigned char CMD);
void LCD_WriteData (unsigned char Data);
void LCD_Display_Off(void);
void LCD_Display_On(void);
void LCD_Clear(void);
void LCD_Home(void);
void LCD_Cursor(char row, char column);
void LCD_Cursor_On(void);
void LCD_Cursor_Off(void);
void LCD_DisplayCharacter(char Char);
void LCD_DisplayString_F(char row, char column, unsigned char __flash *string);
void LCD_DisplayString (char row, char column ,unsigned char *string);

void KeyProcess(void); //按键检测

int Init_DS18B20(void);
int Read_Temperature(void);
uchar Read_DS18B20(void);
uchar Write_DS18B20(uchar value);

void StartI2C();
void StopI2C();
unsigned char ReadI2CAck();
unsigned char ReadI2CNoAck();
bit WriteI2C(unsigned char dat);
unsigned char ReadADC(unsigned char channel);




#endif