//+------------------------------------------------------------------+
//|                                                    TimeTrade.mq5 |
//|                                                   Denis Dyakonov |
//+------------------------------------------------------------------+
#property copyright "Denis Dyakonov"
#property link      ""
#property version   "1.00"
#include <tim.mqh>
string RealTimeServer;
string RealTimeYear;
string RealTimeMonth;
string Hor;
string Minut;
bool time;
int TimePeriod = 0;

enum PERIOD {PERIOD_M5};
input double OPEN_PRICE = 200;  // Open Price
input double STOP_LOSS  = 100;  // Stop Loss
input double TRAIL_STOP = 100;  // Trailing
input double LOT        = 1;    // Volume

input bool   HOUR_0     = true;   // Hour 0
input bool   HOUR_1     = true;   // Hour 1
input bool   HOUR_2     = true;   // Hour 2
input bool   HOUR_3     = true;   // Hour 3
input bool   HOUR_4     = true;   // Hour 4
input bool   HOUR_5     = true;   // Hour 5
input bool   HOUR_6     = true;   // Hour 6
input bool   HOUR_7     = true;   // Hour 7
input bool   HOUR_8     = true;   // Hour 8
input bool   HOUR_9     = true;   // Hour 9
input bool   HOUR_10    = true;   // Hour 10
input bool   HOUR_11    = true;   // Hour 11
input bool   HOUR_12    = true;   // Hour 12
input bool   HOUR_13    = true;   // Hour 13
input bool   HOUR_14    = true;   // Hour 14
input bool   HOUR_15    = true;   // Hour 15
input bool   HOUR_16    = true;   // Hour 16
input bool   HOUR_17    = true;   // Hour 17
input bool   HOUR_18    = true;   // Hour 18
input bool   HOUR_19    = true;   // Hour 19
input bool   HOUR_20    = true;   // Hour 20
input bool   HOUR_21    = true;   // Hour 21
input bool   HOUR_22    = true;   // Hour 22
input bool   HOUR_23    = true;   // Hour 23

double bid;
double ask;
double spread;
double limit;
bool prices = false;
ENUM_ORDER_TYPE type_Buy  = ORDER_TYPE_BUY_STOP;
ENUM_ORDER_TYPE type_Sell = ORDER_TYPE_SELL_STOP;
double balance;
double RealFreeBalance;
double balances;
double balanceFreeMargin;
double res_Buy;
double res_Sell;
//+------------------------------------------------------------------+
//| Expert start function                                            |
//+------------------------------------------------------------------+
int OnInit()
  {
//+------------------------------------------------------------------+
//| Price.mqh                                                        |
//+------------------------------------------------------------------+
   MqlTick price;
   if(SymbolInfoTick(Symbol(),price)==true)
     {
      bid = price.bid;
      ask = price.ask;
      spread = NormalizeDouble(ask-bid,Digits());
     }
   else
     {
      prices = false;
     }
//+------------------------------------------------------------------+
//| Price.mqh                                                        |
//+------------------------------------------------------------------+
   Sleep(3000);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   MqlTick price;
   if(SymbolInfoTick(Symbol(),price)==true)
     {
      bid = price.bid;
      ask = price.ask;
      prices = true;
      spread = NormalizeDouble(ask-bid,Digits());
     }
   else
     {
      prices = false;
     }
//+------------------------------------------------------------------+
//| Price                                                            |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| OrderModifyActive                                                |
//+------------------------------------------------------------------+
   MqlTradeRequest request1;
   MqlTradeResult result1;
   int total1=PositionsTotal();
   for(int i=0; i<total1; i++)
     {
      ulong position_ticket = PositionGetTicket(i);
      double sl=PositionGetDouble(POSITION_SL);
      string coment = PositionGetString(POSITION_COMMENT);
      double price1 = PositionGetDouble(POSITION_PRICE_OPEN);
      double stl_Buy  = NormalizeDouble(bid-TRAIL_STOP*Point(),Digits());
      double stl_Sell = NormalizeDouble(ask+TRAIL_STOP*Point(),Digits());
      if((coment == (Symbol() + "_Time_BUY"))   &&
         (bid > price1+spread)                  &&
         (stl_Buy != sl)                        &&
         (stl_Buy > sl)                         &&
         (prices == true))
        {
         ZeroMemory(request1);
         ZeroMemory(result1);
         request1.action = TRADE_ACTION_SLTP;
         request1.position = position_ticket;
         request1.sl = stl_Buy;
         if(!OrderSend(request1,result1))
            PrintFormat("Error modify BUY %d", GetLastError());
        }
      if((coment == (Symbol() + "_Time_SELL"))  &&
         (ask < price1-spread)                  &&
         (stl_Sell != sl)                       &&
         (stl_Sell < sl)                        &&
         (prices == true))
        {
         ZeroMemory(request1);
         ZeroMemory(result1);
         request1.action = TRADE_ACTION_SLTP;
         request1.position = position_ticket;
         request1.sl = stl_Sell;
         if(!OrderSend(request1,result1))
            PrintFormat("Error modify SELL %d", GetLastError());
        }
     }
//+------------------------------------------------------------------+
//| Time server                                                      |
//+------------------------------------------------------------------+
   RealTimeServer = TimeToString(TimeCurrent());
   RealTimeYear   = RealTimeServer.Substr(0,4);
   RealTimeMonth  = RealTimeServer.Substr(5,2);
   Hor    = RealTimeServer.Substr(11,2);
   Minut  = RealTimeServer.Substr(14,2);
   if((RealTimeMonth == "11") || (RealTimeMonth == "12") || (RealTimeMonth == "01") || (RealTimeMonth == "02") || (RealTimeMonth == "03"))
     {
      TimePeriod = 1;
     }
   else
     {
      TimePeriod = 2;
     }
//+------------------------------------------------------------------+
//| Orders delite                                                    |
//+------------------------------------------------------------------+
   if((Minut == "06") && (time == false))
     {
      OrdersModifyPerspective();
      time = true;
     }
   if((Minut == "11") && (time == false))
     {
      OrdersModifyPerspective();
      time = true;
     }
   if((Minut == "16") && (time == false))
     {
      OrdersModifyPerspective();
      time = true;
     }
   if((Minut == "21") && (time == false))
     {
      OrdersModifyPerspective();
      time = true;
     }
   if((Minut == "26") && (time == false))
     {
      OrdersModifyPerspective();
      time = true;
     }
   if((Minut == "31") && (time == false))
     {
      OrdersModifyPerspective();
      time = true;
     }
   if((Minut == "36") && (time == false))
     {
      OrdersModifyPerspective();
      time = true;
     }
   if((Minut == "41") && (time == false))
     {
      OrdersModifyPerspective();
      time = true;
     }
   if((Minut == "46") && (time == false))
     {
      OrdersModifyPerspective();
      time = true;
     }
   if((Minut == "51") && (time == false))
     {
      OrdersModifyPerspective();
      time = true;
     }
   if((Minut == "56") && (time == false))
     {
      OrdersModifyPerspective();
      time = true;
     }
   if((Minut == "01") && (time == false))
     {
      OrdersModifyPerspective();
      time = true;
     }
//---------------------------------------------------------------------------
   if(AccountInfoDouble(ACCOUNT_MARGIN_FREE)>4000)
     {
      switch(TimePeriod)
        {
         case 1:
            if((HOUR_0)  && (Hor == "00")) tim();
            if((HOUR_1)  && (Hor == "01")) tim();
            if((HOUR_2)  && (Hor == "02")) tim();
            if((HOUR_3)  && (Hor == "03")) tim();
            if((HOUR_4)  && (Hor == "04")) tim();
            if((HOUR_5)  && (Hor == "05")) tim();
            if((HOUR_6)  && (Hor == "06")) tim();
            if((HOUR_7)  && (Hor == "07")) tim();
            if((HOUR_8)  && (Hor == "08")) tim();
            if((HOUR_9)  && (Hor == "09")) tim();
            if((HOUR_10) && (Hor == "10")) tim();
            if((HOUR_11) && (Hor == "11")) tim();
            if((HOUR_12) && (Hor == "12")) tim();
            if((HOUR_13) && (Hor == "13")) tim();
            if((HOUR_14) && (Hor == "14")) tim();
            if((HOUR_15) && (Hor == "15")) tim();
            if((HOUR_16) && (Hor == "16")) tim();
            if((HOUR_17) && (Hor == "17")) tim();
            if((HOUR_18) && (Hor == "18")) tim();
            if((HOUR_19) && (Hor == "19")) tim();
            if((HOUR_20) && (Hor == "20")) tim();
            if((HOUR_21) && (Hor == "21")) tim();
            if((HOUR_22) && (Hor == "22")) tim();
            if((HOUR_23) && (Hor == "23")) tim();
         case 2:
            if((HOUR_0)  && (Hor == "23")) tim();
            if((HOUR_1)  && (Hor == "00")) tim();
            if((HOUR_2)  && (Hor == "01")) tim();
            if((HOUR_3)  && (Hor == "02")) tim();
            if((HOUR_4)  && (Hor == "03")) tim();
            if((HOUR_5)  && (Hor == "04")) tim();
            if((HOUR_6)  && (Hor == "05")) tim();
            if((HOUR_7)  && (Hor == "06")) tim();
            if((HOUR_8)  && (Hor == "07")) tim();
            if((HOUR_9)  && (Hor == "08")) tim();
            if((HOUR_10) && (Hor == "09")) tim();
            if((HOUR_11) && (Hor == "10")) tim();
            if((HOUR_12) && (Hor == "11")) tim();
            if((HOUR_13) && (Hor == "12")) tim();
            if((HOUR_14) && (Hor == "13")) tim();
            if((HOUR_15) && (Hor == "14")) tim();
            if((HOUR_16) && (Hor == "15")) tim();
            if((HOUR_17) && (Hor == "16")) tim();
            if((HOUR_18) && (Hor == "17")) tim();
            if((HOUR_19) && (Hor == "18")) tim();
            if((HOUR_20) && (Hor == "19")) tim();
            if((HOUR_21) && (Hor == "20")) tim();
            if((HOUR_22) && (Hor == "21")) tim();
            if((HOUR_23) && (Hor == "22")) tim();
        }
     }
  }
//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+
void OnTrade()
  {
//---
  }
//+------------------------------------------------------------------+
//| TradeTransaction function                                        |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction& trans,
                        const MqlTradeRequest& request,
                        const MqlTradeResult& result)
  {
//---
  }
//+------------------------------------------------------------------+
bool OpenOrder(ENUM_ORDER_TYPE type1, double PricesMAX,double PricesMIN, double OP_Symbol, double SL_Symbol, string Comm, string DopComm, int pips)
  {
   MqlTradeRequest request = {};
   MqlTradeResult result = {};
   request.action = TRADE_ACTION_PENDING;
   request.symbol = Comm;
   request.volume = LOT;

   if(type1 == ORDER_TYPE_BUY_STOP)
     {
      request.type = type1;
      request.price = NormalizeDouble(PricesMAX+OP_Symbol*Point(),pips);
      request.sl = NormalizeDouble(PricesMIN-SL_Symbol*Point(),pips);
      request.comment = Comm + DopComm;
      if(!OrderSend(request,result))
        {PrintFormat(Comm+DopComm, " - Error open order - %d", GetLastError());}

     }
   if(type1 == ORDER_TYPE_SELL_STOP)
     {
      request.type = type1;
      request.price = NormalizeDouble(PricesMIN-OP_Symbol*Point(),pips);
      request.sl = NormalizeDouble(PricesMAX+SL_Symbol*Point(),pips);
      request.comment = Comm + DopComm;
      if(!OrderSend(request,result))
        {PrintFormat(Comm+DopComm, " - Error open order - %d", GetLastError());}

     }
   time = false;
   return(true);
  }
//+------------------------------------------------------------------+
void OrdersModifyPerspective()
  {
   MqlTradeRequest request2 = {};
   MqlTradeResult result2 = {};
   int total2=OrdersTotal();
   for(int i=total2-1; i>=0; i--)
     {
      ulong  order_ticket=OrderGetTicket(i);
      ZeroMemory(request2);
      ZeroMemory(result2);
      request2.action=TRADE_ACTION_REMOVE;
      request2.order = order_ticket;
      if(!OrderSend(request2,result2))
         PrintFormat("OrderSend error %d",GetLastError());
     }
  };
//+------------------------------------------------------------------+
