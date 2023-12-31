#include <mega16.h>
#include "delay.h"
#include "includes.h"
#include "stdio.h"
bit ack;
unsigned char midval;
uchar state;
char disdat[14]; //打印数组初始化
char disset[16];
int refreshFlag = 0;
int temp;
float temperature = 0;
float Lv = 0.0;             //光照采集电压
float Tv = 0.0;             //土壤采集电压
unsigned int Lval = 0;      //光照强度
unsigned int Rval = 0;      //土壤湿度
unsigned int dispTemp;      //显示温度
unsigned char rekey = 0;    //按键防止重复
unsigned char setIndex = 0; //设置值
unsigned char setLval = 50;
unsigned char setRval = 50;
unsigned char setTval = 35;
void lcd_set_e(void) {
    PORTD.1 |= 1;
}
void lcd_clear_e(void) {
    PORTD.1 &= 0;
}
// External Interrupt 0 service routine
interrupt[EXT_INT0] void ext_int0_isr(void)
{
    // Place your code here
    if (setIndex == 1) //设光照阈值
    {
        if (setLval < 99) //不超过99
        {
            setLval++;
        }
    }
    else if (setIndex == 2) //设土壤阈值
    {
        if (setRval < 99) //不超过99
        {
            setRval++;
        }
    }
    else if (setIndex == 3) //温度设置
    {
        if (setTval < 99) //不超过99
        {
            setTval++;
        }
    }
}
// External Interrupt 1 service routine
interrupt[EXT_INT1] void ext_int1_isr(void)
{
    // Place your code here
    if (setIndex == 1) //设光照阈值
    {
        if (setLval > 0) //最小为0
        {
            setLval--;
        }
    }
    else if (setIndex == 2) //设土壤阈值
    {
        if (setRval > 0) //最小为0
        {
            setRval--;
        }
    }
    else if (setIndex == 3) //温度设置
    {
        if (setTval > 0) //最小为0
        {
            setTval--;
        }
    }
}
// External Interrupt 2 service routine
interrupt[EXT_INT2] void ext_int2_isr(void)
{
    // Place your code here
    setIndex++;
    if (setIndex > 3)
    {
        setIndex = 0; //取消设置
    }
}
int Init_DS18B20(void)
{
    int temp;
    //主机发送480-960us的低电平
    DQ_DIR_OUT();
    DQ_SET();
    delay_us(10);
    DQ_CLEAR();
    delay_us(750);
    DQ_SET();
    //从机拉低60-240us响应
    DQ_DIR_IN();
    delay_us(150);
    temp = DQ_DATA;
    delay_us(500);
    return temp;
}

void LCD_INIT(void)
{
	DDRD.1 = 1;
	LCD_DIR_PORT = 0xff; // LCD port output
	LCD_OP_PORT = 0x30; // Load high-data to port
	lcd_clear_rw(); // Set LCD to write
	lcd_clear_rs(); // Set LCD to command
	lcd_set_e(); // Write data to LCD
	delay_us(10);
	lcd_clear_e(); // Disable LCD
	delay_us(40);
	lcd_clear_rw() ; // Set LCD to write
	lcd_clear_rs(); // Set LCD to command
	lcd_set_e(); // Write data to LCD
	delay_us(10);
	lcd_clear_e(); // Disable LCD
	delay_us(40);
	lcd_set_e(); // Write data to LCD
	delay_us(10);
	lcd_clear_e(); // Disable LCD
	delay_us(40);
	LCD_OP_PORT = 0x20;
	lcd_set_e(); // Write data to LCD
	delay_us(10);
	lcd_clear_e(); // Disable LCD
	delay_us(40);
	DDRB.2 |= 0;
}
//*****************************************************//
// This routine will return the busy flag from the LCD //
//*****************************************************//
void LCD_Busy ( void )
{
	unsigned char temp,high;
	unsigned char low;
	LCD_DIR_PORT = 0x0f; // Make I/O Port input
	do
	{
		temp=LCD_OP_PORT;
		temp=temp&BIT3;
		LCD_OP_PORT=temp;
		lcd_set_rw(); // Set LCD to READ
		lcd_clear_rs();
		lcd_set_e();
		delay_us(3);
		high = LCD_IP_PORT; // read the high nibble.
		lcd_clear_e(); // Disable LCD
		lcd_set_e();
		
		low = LCD_IP_PORT; // read the low nibble.
		lcd_clear_e(); // Disable LCD
	} while(high & 0x80);
	delay_us(20);
}
// ********************************************** //
// *** Write a control instruction to the LCD *** //
// ********************************************** //
void LCD_WriteControl (unsigned char CMD)
{
	char temp;
	LCD_Busy(); // Test if LCD busy
	LCD_DIR_PORT = 0xff; // LCD port output
	temp=LCD_OP_PORT;
	temp=temp&BIT3;
	LCD_OP_PORT =(CMD & 0xf0)|temp; // Load high-data to port
	lcd_clear_rw(); // Set LCD to write
	lcd_clear_rs(); // Set LCD to command
	lcd_set_e(); // Write data to LCD
	delay_us(10);
	lcd_clear_e(); // Disable LCD
	LCD_OP_PORT =(CMD<<4)|temp; // Load low-data to port
	lcd_clear_rw(); // Set LCD to write
	lcd_clear_rs(); // Set LCD to command
	lcd_set_e(); // Write data to LCD
	delay_us(10);
	lcd_clear_e(); // Disable LCD
}
// ***************************************** //
// *** Write one byte of data to the LCD *** //
// ***************************************** //
void LCD_WriteData (unsigned char Data)
{
	char temp;
	LCD_Busy(); // Test if LCD Busy
	LCD_DIR_PORT = 0xFF; // LCD port output
	temp=LCD_OP_PORT;
	temp=temp&BIT3;
	LCD_OP_PORT =(Data & 0xf0)|temp; // Load high-data to port
	lcd_clear_rw() ; // Set LCD to write
	lcd_set_rs(); // Set LCD to data
	lcd_set_e(); // Write data to LCD
	delay_us(10);
	lcd_clear_e(); // Disable LCD
	LCD_OP_PORT = (Data << 4)|temp; // Load low-data to port
	lcd_clear_rw() ; // Set LCD to write
	lcd_set_rs(); // Set LCD to data
	lcd_set_e(); // Write data to LCD
	delay_us(10);
	lcd_clear_e(); // Disable LCD
}
// ********************************* //
// *** Initialize the LCD driver *** //
// ********************************* //
void Init_LCD(void)
{
	LCD_INIT();
	LCD_WriteControl (LCD_FUNCTION_SET);
	LCD_WriteControl (LCD_OFF);
	LCD_WriteControl (LCD_CLEAR);
	LCD_WriteControl (LCD_MODE_SET);
	LCD_WriteControl (LCD_ON);
	LCD_WriteControl (LCD_HOME);
}
// ************************************************ //
// *** Clear the LCD screen (also homes cursor) *** //
// ************************************************ //
void LCD_Clear(void)
{
	LCD_WriteControl(0x01);
}
// *********************************************** //
// *** Position the LCD cursor at row 1, col 1 *** //
// *********************************************** //
void LCD_Home(void)
{
	LCD_WriteControl(0x02);
}
// ****************************************************************** //
// *** Display a single character, at the current cursor location *** //
// ****************************************************************** //
void LCD_DisplayCharacter (char Char)
{
	LCD_WriteData (Char);
}
// ********************************************************************* //
// *** Display a string at the specified row and column, using FLASH *** //
// ********************************************************************* //
void LCD_DisplayString_F (char row, char column , unsigned char __flash *string)
{
	LCD_Cursor (row, column);
	while (*string)
	{
	LCD_DisplayCharacter (*string++);
	}
}
// ******************************************************************* //
// *** Display a string at the specified row and column, using RAM *** //
// ******************************************************************* //
void LCD_DisplayString (char row, char column ,unsigned char *string)
{
	LCD_Cursor (row, column);
	while (*string)
		LCD_DisplayCharacter (*string++);
}
// *************************************************** //
// *** Position the LCD cursor at "row", "column". *** //
// *************************************************** //
void LCD_Cursor (char row, char column)
{
	switch (row) {
	case 1: LCD_WriteControl (0x80 + column - 1); break;
	case 2: LCD_WriteControl (0xc0 + column - 1); break;
	case 3: LCD_WriteControl (0x94 + column - 1); break;
	case 4: LCD_WriteControl (0xd4 + column - 1); break;
	default: break;
}
}
// ************************** //
// *** Turn the cursor on *** //
// ************************** //
void LCD_Cursor_On (void)
{
	LCD_WriteControl (LCD_CURS_ON);
}
// *************************** //
// *** Turn the cursor off *** //
// *************************** //
void LCD_Cursor_Off (void)
{
	LCD_WriteControl (LCD_ON);
}
// ******************** //
// *** Turn Off LCD *** //
// ******************** //
void LCD_Display_Off (void)
{
	LCD_WriteControl(LCD_OFF);
}
// ******************* //
// *** Turn On LCD *** //
// ******************* //
void LCD_Display_On (void)
{
	LCD_WriteControl(LCD_ON);
}

uchar Read_DS18B20(void)
{
    uchar value = 0;
    int i;
    for(i=0;i<8;i++)
    {
        //主机拉低总线并释放
        DQ_DIR_OUT();
        DQ_SET();
        delay_us(1);
        DQ_CLEAR();
        delay_us(1);
        DQ_SET();
        //读数据位
        DQ_DIR_IN();
        delay_us(7);
        value |= (DQ_DATA<<i);
        delay_us(70);
    }
    return value;
}

uchar Write_DS18B20(uchar value)
{
    int i;
    DQ_DIR_OUT();
    for(i=0;i<8;i++)
    {
        //主机拉低总线
        DQ_SET();
        delay_us(1);
        DQ_CLEAR();
        //写数据位
        if(((value&(1<<i)))!=0)
        {
            DQ_SET();
        }
        else
        {
            DQ_CLEAR();
        }
        delay_us(70);
        DQ_SET();
        delay_us(10);
    }
    delay_us(10);
}



//读取温度
int Read_Temperature(void)
{
    char temp_l, temp_h;
    int temp;
    #asm("cli")
    Init_DS18B20();
    Write_DS18B20(0xCC); //跳过ROM
    Write_DS18B20(0x44); //温度转换
    #asm("sei");
    delay_ms(200); //等待温度转换
    #asm("cli")
    Init_DS18B20();
    Write_DS18B20(0xCC); //跳过ROM
    Write_DS18B20(0xBE); //读RAM数据
    temp_l = Read_DS18B20(); //读前两字节数据
    temp_h = Read_DS18B20();
    #asm("sei")
    if((temp_h&0xf8)!=0x00)
    {
        state=1;         //此时温度为零下，即为负数
        temp_h=~temp_h;
        temp_l=~temp_l;
        temp_l +=1;
        if(temp_l>255)
            temp_h++;
    }
        temp=temp_h;
        temp&=0x07;
        temp=((temp_h*256)+temp_l)*0.625+0.5;
    //处理数据
    //temp = (temp_h*256+temp_l)*6.25;
    return temp/10;
}



void main(void)
{
    #asm("sei")
    Init_LCD(); 
    LCD_Clear();  
    DDRA=11111000; 
    PORTA=00000111; 
    DDRD.6=0; 
    PORTD.6=1;
    DDRD.7=0; 
    PORTD.7=1;    
    DDRD.0=1; 
    PORTD.0=1;
    GICR |= 0xE0; //INT2：On；INT1: On；INT0: On
    MCUCR = 0x0A; //INT1、INT0下降沿产生中断
    MCUCSR = 0x00;//INT2：下降沿产生中断
    GIFR = 0xE0; //清除INT2、INT1、INT0中断标志
    LED_WHITE = 0;
    RELAY = 0;
    LED_YELLOW = 0;
    FAN = 0; //上电检测下 方便检测硬件
    delay_ms(200);
    LED_WHITE = 1;
    RELAY = 1;
    LED_YELLOW = 1;
    FAN = 0;   
    
    while (1)
      { 
         dispTemp = Read_Temperature();
         midval = ReadADC(1);                    //转换的结果，在下次，才能读出
         Lv = 5.00 - (float)midval * 5.00 / 255; //光照
         Lval = (unsigned int)(Lv *99) / 5.00;
         delay_ms(10); //延时有助于稳定
         midval = ReadADC(0);                    //读取AD检测到的
         Tv = 5.00 - (float)midval * 5.00 / 255; //土壤湿度
         Rval = (unsigned int)(Tv *99) / 5.00;
         delay_ms(20);
         sprintf(disdat, "L:%2d R:%2d T:%2d", Lval, Rval, dispTemp); //打印电压电流值
         LCD_DisplayString(1, 2, disdat);  
         if (setIndex == 1) //进入设置
            {
                sprintf(disset, "*L:%2d R:%2d T:%2d ", (unsigned int)setLval, (unsigned int)setRval, (unsigned int)setTval); //打印电压电流值
            }
         else if (setIndex == 2)
            {
                sprintf(disset, " L:%2d*R:%2d T:%2d ", (unsigned int)setLval, (unsigned int)setRval, (unsigned int)setTval); //打印电压电流值
            }
         else if (setIndex == 3)
            {
                sprintf(disset, " L:%2d R:%2d*T:%2d ", (unsigned int)setLval, (unsigned int)setRval, (unsigned int)setTval); //打印电压电流值
            }
         else
            {
                sprintf(disset, " L:%2d R:%2d T:%2d ", (unsigned int)setLval, (unsigned int)setRval, (unsigned int)setTval); //打印电压电流值
            } 
         if (Lval <= setLval) //光照对比
            {
                LED_WHITE = 0; //打开补光灯
            }
            else
            {
                LED_WHITE = 1; //关闭补光灯
            }

            if (Rval <= setRval) //土壤对比
            {
                RELAY = 0; //打开水泵继电器
            }
            else
            {
                RELAY = 1; //关闭水泵继电器
            }

            
            if (dispTemp < setTval) //温度对比
            {
                LED_YELLOW = 0; //打开补温灯
                FAN = 1; //关闭风扇
            }
            else if (dispTemp > setTval)
            {
                LED_YELLOW = 1; //关闭补温灯
                FAN = 0; //打开风扇
            }
            else
            {
                LED_YELLOW = 1; //关闭补温灯
                FAN = 1; //关闭风扇
            }
   
            
         LCD_DisplayString(2, 1, disset); 
//         KeyProcess();  
      }
}


void I2C_SCL_IN(void)
{
    DDRC.0 = 0;
    PORTC.0 = 1;
    delay_us(5);
}
void I2C_SDA_IN(void)
{
    DDRC.1 = 0;
    PORTC.1 = 1;
    delay_ms(5);
}
void I2C_SDA_OUT(void)
{
    DDRC.1 = 1;
    delay_us(5);
}
void I2C_SCL_OUT(void)
{
    DDRC.0 = 1;
    delay_us(5);
}

void StartI2C()
{
    I2C_SCL_OUT();
    I2C_SDA_OUT();
    I2C_SDA_PORT = 1;
    I2C_SCL_PORT = 1;
    delay_us(10);
    I2C_SDA_PORT = 0;
    delay_us(10);
    I2C_SCL_PORT = 0;
}

void StopI2C()
{
    I2C_SCL_OUT();
    I2C_SDA_OUT();
    I2C_SDA_PORT = 0;
    I2C_SCL_PORT = 0;
    delay_us(10);
    I2C_SCL_PORT = 1;
    delay_us(10);
    I2C_SDA_PORT = 1;
}

bit WriteI2C(unsigned char dat)
{
    bit ack;
    unsigned char mask;
    I2C_SCL_OUT();
    I2C_SDA_OUT();
    for (mask=0x80; mask!=0; mask>>=1)
    {
        if ((mask&dat) == 0)
            I2C_SDA_PORT = 0;
        else
            I2C_SDA_PORT = 1;
        delay_us(10);
        I2C_SCL_PORT = 1;
        delay_us(10);
        I2C_SCL_PORT = 0;
    }
    I2C_SDA_PORT = 1;    //8位数据发送完毕之后，主动释放SDA，以检测从机应答
    delay_us(10);
    I2C_SDA_IN();
    I2C_SCL_PORT = 1;
    delay_us(10);
    ack = I2C_SDA_PIN;  //读取此时的SDA 值，即为从机的应答值
    delay_us(10);
    I2C_SCL_PORT = 0;    //再拉低SCL 完成应答位，并保持住总线
    return (~ack);  //应答值取反以符合通常的逻辑：0=不存在或忙或写入失败，1=存在且空闲或写入成功
}

//读I2C，并应答
unsigned char ReadI2CAck()
{
    unsigned char mask;
    unsigned char dat;
    I2C_SCL_OUT();
    I2C_SDA_OUT();
    I2C_SDA_PORT = 1;
    I2C_SDA_IN();
    for (mask=0x80; mask!=0; mask>>=1)
    {
        delay_us(10);
        I2C_SCL_PORT = 1;        //拉高SCL
        delay_us(10);
        if (I2C_SDA_PIN == 0)   //读取SDA 的值
            dat &= ~mask;   //为0 时，dat 中对应位清零
        else
            dat |= mask;    //为1 时，dat 中对应位置1  
        delay_us(10);
        I2C_SCL_PORT = 0;        //再拉低SCL，以使从机发送出下一位
        I2C_SDA_OUT();
        delay_us(10);
    }
    I2C_SDA_PORT = 0;    //8 位数据发送完后，拉低SDA，发送应答信号
    delay_us(10);
    I2C_SCL_PORT = 1;    //拉高SCL
    delay_us(10);
    I2C_SCL_PORT = 0;    //再拉低SCL 完成应答位，并保持住总线
    return dat;
}

//读I2C，但不应答
unsigned char ReadI2CNoAck()
{
    unsigned char mask;
    unsigned char dat;
    I2C_SDA_OUT();
    I2C_SCL_OUT();
    I2C_SDA_PORT = 1;
    for (mask=0x80; mask!=0; mask>>=1)
    {
        delay_us(10);
        I2C_SDA_IN();
        delay_us(10);
        I2C_SCL_PORT = 1;        //拉高SCL
        delay_us(10);
        if (I2C_SDA_PIN == 0)   //读取SDA 的值
            dat &= ~mask;   //为0 时，dat 中对应位清零
        else
            dat |= mask;    //为1 时，dat 中对应位置1
        delay_us(10);
        I2C_SCL_PORT = 0;        //再拉低SCL，以使从机发送出下一位
    }
    I2C_SDA_OUT();
    delay_us(10);
    I2C_SDA_PORT = 1;    //8 位数据发送完后，拉高SDA，发送非应答信号
    delay_us(10);
    I2C_SCL_PORT = 1;    //拉高SCL
    delay_us(10);
    I2C_SCL_PORT = 0;    //再拉低SCL 完成应答位，并保持住总线
    return dat;
}

unsigned char ReadADC(unsigned char channel)
{
    bit ack = 0;
    unsigned char dat = 0;
    StartI2C();
    do 
    {
        ack = WriteI2C(ADDR_WR);
    }while (!ack);
    WriteI2C(0x00 | channel);
    StopI2C();
    StartI2C();
    do 
    {
        ack = WriteI2C(ADDR_RD);
    }while (!ack);
    ReadI2CAck(); //丢弃上一次的转换值
    dat = ReadI2CNoAck();  //获取最新的转换值
    StopI2C();
    return dat;
}
