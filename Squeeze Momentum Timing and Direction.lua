instrument {
    name = 'Squeeze Momentum Timing and Direction',
    icon = 'indicators:AO',
    overlay = false
}

length=input(20,"Squeeze Length",input.integer)
multBB=input(2,"BB MultFactor",input.integer)
multKC=input(1.5,"KC MultFactor",input.double)
smooth=input(20,"Momentum Smoothing",input.integer)

usebbr=input(true,"Use Bollinger Band Ratio",input.boolean)
useHA=input(true,"Use Heikin Ashi Candle",input.boolean)
useTrueRange=input(true,"Use TrueRange (KC)",input.boolean)

--Calculate BB
source=iff(useHA,ohlc4,close)
basis=sma(source,length)
dev=multBB*stdev(source,length)
upperBB=basis+dev
lowerBB=basis-dev

--Calculate KC
ma=sma(source,length)
range=iff(useTrueRange,tr,(high-low))
rangema=sma(range,length)
upperKC=ma+rangema*multKC
lowerKC=ma-rangema*multKC

sqzOn=(lowerBB>lowerKC) and (upperBB<upperKC)
sqzOff=(lowerBB<lowerKC) and (upperBB>upperKC)
noSqz=(sqzOn==false) and (sqzOff==false)

momentum=iff(usebbr,(((source - lowerBB)/(upperBB - lowerBB))-0.5),(((close - close[12])/close[12])*100))

val=sma(momentum,smooth)

bcolor = iff(val > 0, iff( val > nz(val[1]), 'green', 'blue'),iff(val < nz(val[1]), 'red', 'orange'))
scolor=iff(noSqz,'blue',iff(sqzOn,'red','lime'))

rect{
    first=0,
    second=val,
    color=bcolor,
    width=0.7
}

plot(0,"Zero Line",scolor,1,0,style.points)



