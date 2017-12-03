//
//  CGLOperater.cpp
//  Purika
//
//  Created by sugc on 18/06/2017.
//  Copyright © 2017 魔方. All rights reserved.
//

#include "CGLOperater.hpp"
#include "math.h"
#include <iostream>
//#include <wingdi.h>
#include <fstream>
#include <stdio.h>
#include <ImageIO/ImageIO.h>

using namespace std;

int bmpwidth,bmpheight,linebyte;
unsigned char *pBmpBuf;

void bilateralFilter(unsigned char* pSrc, unsigned char* pDest, int width, int height, int radius){
    float delta = 0.1f;	float eDelta = 1.0f / (2 * delta * delta);
    int colorDistTable[256 * 256] = { 0 };
    for (int x = 0; x < 256; x++)
        {		int  * colorDistTablePtr = colorDistTable + (x * 256);
            for (int y = 0; y < 256; y++){
                int  mod = ((x - y) * (x - y))*(1.0f / 256.0f);
                colorDistTablePtr[y] = 256 * exp(-mod * eDelta);
            }
        }
    for (int Y = 0; Y < height; Y++){
        int Py = Y * width;
        unsigned char* LinePD = pDest + Py;
        unsigned char* LinePS = pSrc + Py;
        for (int X = 0; X < width; X++) {
            int sumPix = 0;int sum = 0;
            int factor = 0;
            for (int i = -radius; i <= radius; i++){
                unsigned char* pLine = pSrc + ((Y + i + height) % height)* width;
                int cPix = 0;
                int  * colorDistPtr = colorDistTable + LinePS[X] * 256;
                for (int j = -radius;j <= radius; j++)	{
                    cPix = pLine[ (X + j+width)%width];
                    factor = colorDistPtr[cPix];
                    sum += factor;
                    sumPix += (factor *cPix);
                }
            }
            LinePD[X] = (sumPix / sum);
        }
    }
}


bool readBmp(char *bmpName)
{
    FILE *fp;
    if( (fp = fopen(bmpName,"rb")) == NULL)  //以二进制的方式打开文件
    {
        cout<<"The file "<<bmpName<<"was not opened"<<endl;
        return false;
    }
//    if(fseek(fp,sizeof(BITMAPFILEHEADER),0))  //跳过BITMAPFILEHEADE
    {
        cout<<"跳转失败"<<endl;
        return false;
    }
//    BITMAPINFOHEADER infoHead;
//    fread(&infoHead,sizeof(BITMAPINFOHEADER),1,fp);   //从fp中读取BITMAPINFOHEADER信息到infoHead中,同时fp的指针移动
//    bmpwidth = infoHead.biWidth;
//    bmpheight = infoHead.biHeight;
    linebyte = (bmpwidth*24/8+3)/4*4; //计算每行的字节数，24：该图片是24位的bmp图，3：确保不丢失像素
    
    //cout<<bmpwidth<<" "<<bmpheight<<endl;
    pBmpBuf = new unsigned char[linebyte*bmpheight];
    fread(pBmpBuf,sizeof(char),linebyte*bmpheight,fp);
    fclose(fp);   //关闭文件
    return true;
}
void solve()
{
    char readFileName[] = "nv.BMP";
    if(false == readBmp(readFileName))
    cout<<"readfile error!"<<endl;
}




