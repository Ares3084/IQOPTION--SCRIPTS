instrument {
    name = 'Alpha-Sutte Model',
    icon = 'indicators:MA',
    overlay = true
}

--Alpha Sutte
delta=close[4]
alpha=close[3]
beta=close[2]
gamma=close[1]

x=alpha-delta
y=beta-alpha
z=gamma-beta
a=alpha+delta
b=beta+alpha
g=gamma+beta
P1=x/a 
P1a=P1/2
P1b=P1a*alpha
P2 = y / b
P2a = P2 / 2
P2b = P2a * beta
P3 = z / g
P3a = P3 / 2
P3b = P3a * gamma
greeksum = P1b + P2b + P3b
a_t = greeksum / 3
a_t0 = a_t + close[1]
--plot(a_t0, "Alpha-Sutte",'blue',2)

--Sutte
SutteL = (close + close[1]) / 2 + close - low
SutteH = (close + close[1]) / 2 + high - close
Sutte = (SutteL + SutteH) / 2

--Adaptive Alpha Sutte
--Combo=avg(a_t0, Sutte)
--plot(Combo, "Adaptive Alpha Sutte",'yellow',2)

--Sutte High and Low MA's
--En el codigo original es len=1, pero para binarias en TF bajos da muchas senales falsas
len = 5
SutteLMA = sma(SutteL, len)
SutteHMA = sma(SutteH, len)

--When the Sutte Low is greater than the Sutte High you buy, when Sutte High is greater than Sutte Low you sell.
plot(SutteLMA, "Sutte Low MA", 'aqua')
plot(SutteHMA, "Sutte High MA", 'red')

buy=SutteLMA>SutteHMA and SutteLMA[1]<SutteHMA[1]
sell=SutteLMA<SutteHMA and SutteLMA[1]>SutteHMA[1]

plot_shape(sell, "short", shape_style.arrowdown, shape_size.large, 'red', shape_location.abovebar)
plot_shape(buy, "long", shape_style.arrowup, shape_size.large, 'green', shape_location.bottom)