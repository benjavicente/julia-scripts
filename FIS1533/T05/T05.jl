### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 753486c4-2a00-11eb-0e45-091f12e882cc
begin
	using Unitful, Unitful.DefaultSymbols, UnitfulRecipes
	using PlutoUI
	using Plots
	× = *
	# LocalResource
	md"# Desarrollo Tarea 05"
end

# ╔═╡ c96d54fa-2a6c-11eb-2c00-93aaf463858c
md"""
FIS1533 Electricidad y Magnetismo\
Benjamín Vicente - 20 de noviembre 2020
"""

# ╔═╡ 02b19300-2a04-11eb-3e91-89c6fbacf80e
md"## Pregunta 1"

# ╔═╡ c44524d0-2a71-11eb-1ac7-6d04ffa0214f
begin
	campo_magₚ = 0.2T
	ΔV = 1kV
	θₚ = 85°
	masaₚ = 9.10938215 * 10^(-31) * kg
	cargaₚ = 1.602176487 * 10^(-19) * C
end;

# ╔═╡ bf4b49f2-2a6c-11eb-2680-594c91cb4b60
md"""
Considere un campo magnético uniforme de magnitud $(campo_magₚ) el cual está dirigido
a lo largo de la dirección del eje ``x`` positivo. Un positrón, que fue acelerado
mediante una diferencia de potencial de $(ΔV), entra a esta región de campo magnético
con una velocidad ``v`` que forma un ángulo de $(θₚ) con el eje ``x``.
Para este caso en que la trayectoria que describe el positrón es helicoidal,
tal como se muestra en la figura 1, determine:
"""

# ╔═╡ f93f56c6-2b64-11eb-33c2-19606ae42cfd
md""" **Desarrollo**

Antes de realizar una parte del ejericio, se calcula la velocidad.
Como el el potencial es:

```math
\Delta V = \dfrac{\Delta W}{q}
```

y


```math
\Delta W_{\text{al cuerpo}} = \Delta U_{\text{del cuerpo}}

```

se tiene que:

```math
\Delta U_{\text{del cuerpo}} = \Delta V \times q
```

asumiendo que la energía generada a partír del trabajo es solamente cinética y
que el positrón estaba en reposo inicialmente, se tiene que:

```math
\Delta V \times q = \dfrac{m v^2}{2}
```

despejando para la velocidad ``v``:

```math
v = \sqrt{\dfrac{m}{2q\Delta V}}
```
"""

# ╔═╡ ebb46bf8-2b65-11eb-094c-9f385e88c7d9
velocidadₚ = uconvert(m/s, √((2*cargaₚ*ΔV)/masaₚ))

# ╔═╡ 4d187d1a-2a78-11eb-3da6-3fb104725e59
LocalResource("fig1.png", :width => 300)

# ╔═╡ ab7d848c-2a6d-11eb-09b2-976a23edadbd
md"1. El radio ``r`` de la trayectoria helicoidal."

# ╔═╡ 70c7ab24-2a7c-11eb-1632-1f7a87d01cb1
md""" **Desarrollo**

La velocidad se mantiene constante ya que el campo magnético no realiza trabajo.
Por lo tanto, el componente ``\hat{y}`` solo cambia de dirección (``v_r``).
El componente ``\hat{x}`` (``v_x``) no es afectado por el campo, ya que es paralelo
a este, por lo que se ignora para el desarrollo.

Para que el positrón se mantenga en esta trayectoria, debe existír una fuerza
centrípeda probocado por el campo para contrarestar la fuerza centrífuga. 

Por lo tanto, se tiene que:

```math
F_B = F_C 
```

La fuerza centríguda es:

```math
F_C = m\dfrac{{v_r}^2}{r}
```

mientras que la fuerza magnética, al estar ``v_r`` perperdicular a ``B``, es:

```math
F_B = qv_rB
```

entonces, se obtiene que:

```math
m\dfrac{{v_r}^2}{r}  = qv_rB
```

```math
r = m\dfrac{v_r}{qB}
```

```math
r = m\dfrac{v \sin(85°)}{qB}
```
"""

# ╔═╡ e64c2bf6-2a93-11eb-0d23-6d32eaf55a7c
uconvert(m, masaₚ * (velocidadₚ * sin(θₚ)) / (cargaₚ * campo_magₚ))

# ╔═╡ b49cea58-2a6d-11eb-113f-c5cef6f0ff73
md"2. El paso ``p`` de la trayectoria helicoidal."

# ╔═╡ 71a23d96-2a7c-11eb-03b0-57ad53de43c6
md""" **Desarrollo**

El paso ``p`` es:

```math
p = v_x T = v_x \dfrac{2 r \pi}{v_r}
```

remplazando:

```math
p = v \cos(85°) \dfrac{2 r \pi}{v \sin(85°)}
```

```math
p = \dfrac{2 r \pi}{\tan(85°)}
```

tambíen se puede sustiruir ``r``:

```math
p = v \cos(85°) \dfrac{2 mv \sin(85°) \pi}{v \sin(85°)qB}
```

```math
p = v \cos(85°) \dfrac{2 m \pi}{qB}
```
"""

# ╔═╡ 63767c9e-2a94-11eb-011c-45d5675aa058
uconvert(m, velocidadₚ * cos(θₚ) * (2 * masaₚ * π) / (cargaₚ * campo_magₚ))

# ╔═╡ 0b8528d6-2a04-11eb-3868-a104698b3020
md"## Pregunta 2"

# ╔═╡ 7ef8e18a-2a6e-11eb-3f78-63ac63fe0a1f
md"""
Considere una espira de corriente con forma de triángulo rectángulo con catetos de
largo ``a`` y ``b``, que se encuentra en una zona con campo magnético uniforme
``\vec{B}= B\hat{k}``, tal como muestra la figura 2.
Si la corriente ``I`` circula en sentido horario, determine:
"""

# ╔═╡ 708eac10-2a78-11eb-1fce-2707e1d608ff
LocalResource("fig2.png", :width => 300)

# ╔═╡ 90be85b4-2a6e-11eb-1ba0-cbb95854e12d
md"1. La fuerza sobre cada lado del la espira."

# ╔═╡ 599429c8-2a7c-11eb-2100-09cd187c0fe0
md""" **Desarrollo**

La fuerza que que hace el campo magnético está dado por:

```math
\vec{F}_B = I \vec{L} \times \vec{B} = I L B \sin(\theta)
```

con $\vec{L}$ vector con dirección a la corriente y con mangitud el largo del semento.

Para el segmento ``b``, ``\sin(0°) = 0``, por lo que ``\vec{F}_B = 0``

Para el segmento ``a``, ``\sin(90°) = 1``,
entonces con regla de la mano derecha se obtiene que ``\vec{F}_B = IaB \hat{\text{j}}``

Y para el segmento ``c``, se tiene que:

```math
\theta = \arctan\left(\dfrac{a}{b}\right)
```

```math
L = \sqrt{a^2 + b^2}
```

por lo tanto:

```math
F_B = IB \sqrt{a^2 + b^2} \sin\left( \arctan\left(\dfrac{a}{b}\right)\right)
```

que es lo mismo que:

```math
F_B = IB \sqrt{a^2 + b^2} \dfrac{a}{\sqrt{a^2 + b^2}} = IaB
```

y por regla de la mano derecha se obtiene que:

```math
\vec{F}_B = - IaB \hat{\text{j}}
```
"""

# ╔═╡ 9ebc0eac-2a6e-11eb-3b40-3ffa81a599fb
md"2. La fuerza neta sobre la espira."

# ╔═╡ 258c6fe6-2a7c-11eb-248a-8f7c57573498
md""" **Desarrollo**

La fuerza para los segmentos ``a`` y ``c`` se cancelan,
por lo que la fuerza neta es ``0``. 
"""

# ╔═╡ c91efd58-2a6e-11eb-1609-8141a3b9a2df
md"3. El torque neto sobre la espira."

# ╔═╡ 5fb42bb4-2a7c-11eb-061f-3199d78867c0
md""" **Desarrollo**

Como ``b`` no recive fuerza, el eje en el que esá presente el torque está en un puto
en el segmento ``b`` y en el punto ``N``.

Se tiene que el torque, con ``\vec{x}`` la distancia del eje de rotación, es:

```math
\tau = \sum \vec{F} \times \vec{x}
```

El punto en el segmento ``b`` va a estar ``d`` de distancia del punto
``O`` y ``b - d`` del punto ``M``.

Entonces, se tiene que:

```math
\tau = \int_0^d \vec{{F_B}}_a × d\vec{x} + \int_0^{b-d} \vec{{F_B}}_c × d\vec{x}
```

```math
\tau = \int_0^d {F_B}_a \sin(90°) dx + \int_0^{b-d} {F_B}_c \sin(-90°) dx
```

```math
\tau = \int_0^d {F_B}_a dx - \int_0^{b-d} {F_B}_c  dx
```

```math
\tau = IaB  \int_0^d dx + IaB \int_0^{b-d}  dx
```

```math
\tau = IaB  \left( \int_0^d dx + \int_0^{b-d} dx \right) 
```

```math
\tau = IaB (d + b - d) 
```

```math
\tau = IabB 
```
"""

# ╔═╡ 0d74b710-2a04-11eb-32f8-47f7ab3b89c9
md"## Pregunta 3"

# ╔═╡ daa00af4-2a6e-11eb-28c6-3dd2c48173b3
md"""
Considere un anillo circular de radio ``R`` como se muestra en la figura 3,
por el que pasa una corriente ``i``.
"""

# ╔═╡ 13d2567e-2a79-11eb-1441-37d215be11c1
LocalResource("fig3.png", :width => 300)

# ╔═╡ e448285c-2a6e-11eb-0fe4-cd75a816a6d9
md"1. Calcule el campo magnético a lo largo del eje central, ``x``."

# ╔═╡ 671f304c-2a7c-11eb-2faa-17f5f7334bfb
md""" **Desarrollo**


Por ley de Biot-Savart, se tiene que:

```math
d\vec{B} = \dfrac{\mu_0}{4\pi} \dfrac{i d\vec{s} \times \hat{d}}{d^2}
```

donde ``d`` es la distancia entre un punto del anillo y el punto,
y ``d\vec{s}`` es un trozo del aro.

se remplaza ``d\vec{s}`` por ``R\vec{d\theta}`` y se hace el producto cruz:

```math
dB = \dfrac{\mu_0}{4\pi} \dfrac{i R sin(\alpha)}{d^2} d\theta
```

integrando:

```math
B = \dfrac{\mu_0}{4\pi} \dfrac{i R sin(\alpha)}{d^2} \int_0^{2\pi} d\theta
```

```math
B = \dfrac{\mu_0 i R sin(\alpha)}{2d^2}
```


se remplaza ``d`` por una expresión dependiente de ``r``  y ``R``
y ``\sin(\alpha) = R/d``:

```math
B = \dfrac{\mu_0 i R^2 }{2(r^2 + R^2)^{(3/2)}}
```

La dirección del campo no tiene componente ``\hat{\theta}`` porque sería
paralelo a ``d\vec{s} = R\vec{d\theta}``, y tiene componentes ``\hat{R}`` y
``\hat{x}``, ambos no paralelos a ``\vec{d}``. Como se realiza una vuelta al aro,
los lados contrarios anularán el componente ``\hat{R}``, por lo que ``B`` tiene
solo componente ``\hat{x}``.

```math
\vec{B} = \dfrac{\mu_0 i R^2 }{2(r^2 + R^2)^{(3/2)}} \hat{x}
```
"""

# ╔═╡ ecd24052-2a6e-11eb-0bf7-03d20ed504d0
md"""
2. Calcule los campo magnéticos en el centro, ``O`` y un punto muy lejos
   del anillo en el eje ``x``.
"""

# ╔═╡ 68240148-2a7c-11eb-1e7a-d5ae0e57a28c
md""" **Desarrollo**

Para el centro ``O``:

```math
\lim_{r→0} \vec{B} = \dfrac{\mu_0 i R^2 }{2(0 + R^2)^{(3/2)}} \hat{x}
```

```math
\lim_{r→0} \vec{B} = \dfrac{\mu_0 i R^2 }{2R^3} \hat{x}
```

```math
\lim_{r→0} \vec{B} = \dfrac{\mu_0 i}{2R} \hat{x}
```

Para un punto lejos del anillo:

```math
\lim_{r→∞} \vec{B} = \dfrac{\mu_0 i R^2 }{2(\infty + R^2)^{(3/2)}} \hat{x}
```

```math
\lim_{r→∞} \vec{B} = \mu_0 i R^2 \dfrac{1}{\infty} \hat{x} = 0
```

tambien se puede considerar cuando ``r \gg R``:

```math
\vec{B} = \dfrac{\mu_0 i R^2 }{2(r^2)^{(3/2)}} \hat{x}
```

```math
\vec{B} = \dfrac{\mu_0 i R^2 }{2r^3} \hat{x}
```
"""

# ╔═╡ feba060e-2a6e-11eb-24e4-f52f26ad274c
md"3. Grafique la magnitud del campo magnético ``B(x)`` como función de ``x``."

# ╔═╡ 691a22b2-2a7c-11eb-1485-552728c5ea53
md"**Desarrollo**"

# ╔═╡ 5593fca8-2a9d-11eb-0dfd-d363c3e00dbb
begin
	μ₀ = 4π * 10^-7
	i = 1
	R = 1
	B(r) = (μ₀ * i * R^2) / (2 * (r^2 + R^2)^(3//2))
	plot(-1:0.1:5, B, label="B", color=:red)
	hline!([μ₀*i/2R, 0], label=nothing, color=:grey)
	vline!([0], label=nothing, color=:grey)
	xlabel!(raw"Distancia al aro (m)")
	ylabel!(raw"Campo magnético (T)")
	yaxis!(nothing)
end

# ╔═╡ 09b40cb4-2a6f-11eb-1847-431c3326a26f
md"""
4. Calcule a que distancia ``r`` medida desde el centro, la derivada del
   campo magnético es constante. Calcule el campo magnético en esta posición.
"""

# ╔═╡ 6a370458-2a7c-11eb-011e-fb6cefefed75
md""" **Desarrollo**

Se pide buscar cuando ``dB(r)`` es constante, por lo tanto, hay que buscra cuando la
doble derivada de ``B(r)`` con respecto a ``r`` es ``0``.

```math
\left(\dfrac{\partial}{\partial r}\right)^2 B
= \left(\dfrac{\partial}{\partial r}\right)^2 \dfrac{\mu_0 i R^2}{2(r^2+R^2)^{(3/2)}}
= 0
```

simplificando las constantes:

```math
\left(\dfrac{\partial}{\partial r}\right)^2 \dfrac{1}{(r^2+R^2)^{(3/2)}} = 0
```

derivando por primera vez:


```math
\left(\dfrac{\partial}{\partial r}\right) \dfrac{1}{(r^2+R^2)^{(3/2)}}
= - \dfrac{3}{2(r^2+R^2)^{5/2}} 2 r = - \dfrac{3 r}{(r^2+R^2)^{5/2}} 
```

por segunda vez:

```math
\begin{align}
\left(\dfrac{\partial}{\partial r}\right) - \dfrac{3 r}{(r^2+R^2)^{5/2}}
&= - \left( 3\dfrac{1}{(r^2+R^2)^{5/2}} + 3r\dfrac{-5r}{(r^2+R^2)^{7/2}} \right) \\
&= - 3 \left( \dfrac{(r^2+R^2) - 5r}{(r^2+R^2)^{7/2}} \right) \\
&=  \dfrac{3(4r^2 - R^2)}{(r^2+R^2)^{7/2}}
\end{align}
```

Entonces, la derivada de ``B`` es constantes duando:

```math
\dfrac{3(4r^2 - R^2)}{(r^2+R^2)^{7/2}} = 0
```

como ``R > 0``, se tiene que ``r^2+R^2 \neq 0``

```math
4r^2 = R^2
```

```math
2r = R
```

```math
r = \dfrac{R}{2}
```

el campo magnético para ese punto es:

```math
\vec{B} = \dfrac{\mu_0 i R^2 }{2((R/2)^2 + R^2)^{(3/2)}} \hat{x}
```

```math
\vec{B} = \dfrac{\mu_0 i R^2 }{((5/4)R^2)^{(3/2)}} \hat{x}
```

```math
\vec{B} =  \left(\dfrac{4}{5}\right)^{3/2} \dfrac{\mu_0 i}{2R} \hat{x}
```
"""

# ╔═╡ 185a1fe2-2a6f-11eb-3f50-c7566b28b458
md"""
5. Las bobinas de Helmholtz consisten en dos bobinas de radios iguales separadas
   a la distancia ``2r`` calculada en (4), por las cuales circula una corriente
   ``i`` como se muestra en la figura 4. Calcule la magnitud del campo magnético 
   en punto ``P`` equidistante de las bobinas.
"""

# ╔═╡ 273e5c96-2a79-11eb-31a2-69bd6fc70804
LocalResource("fig4.png", :width => 300)

# ╔═╡ 6c0f37fa-2a7c-11eb-266d-39038ad6c0c6
md""" **Desarrollo**


Considerando la ecuación obtenida inicialmente:

```math
\vec{B} = \dfrac{\mu_0 i R^2 }{2(r^2 + R^2)^{(3/2)}} \hat{x}
```

Como para en ambas boninas, el ``r^2`` tiene el mismo valor ya que
``r = \pm R/2``, el campo es simplemente
el doble evaluado en esa posición:

```math
\vec{B} = \dfrac{\mu_0 i R^2 }{((R/2)^2 + R^2)^{(3/2)}} \hat{x}
```

```math
\vec{B} = \left(\dfrac{4}{5}\right)^{3/2} \dfrac{\mu_0 i}{R} \hat{x}
```
"""

# ╔═╡ 00a86d40-2a79-11eb-2b91-95541f56c302
html"<style>img {display: block;margin: 0 auto;}</style>"

# ╔═╡ Cell order:
# ╠═753486c4-2a00-11eb-0e45-091f12e882cc
# ╟─c96d54fa-2a6c-11eb-2c00-93aaf463858c
# ╟─02b19300-2a04-11eb-3e91-89c6fbacf80e
# ╠═c44524d0-2a71-11eb-1ac7-6d04ffa0214f
# ╟─bf4b49f2-2a6c-11eb-2680-594c91cb4b60
# ╟─f93f56c6-2b64-11eb-33c2-19606ae42cfd
# ╠═ebb46bf8-2b65-11eb-094c-9f385e88c7d9
# ╟─4d187d1a-2a78-11eb-3da6-3fb104725e59
# ╟─ab7d848c-2a6d-11eb-09b2-976a23edadbd
# ╟─70c7ab24-2a7c-11eb-1632-1f7a87d01cb1
# ╠═e64c2bf6-2a93-11eb-0d23-6d32eaf55a7c
# ╟─b49cea58-2a6d-11eb-113f-c5cef6f0ff73
# ╟─71a23d96-2a7c-11eb-03b0-57ad53de43c6
# ╠═63767c9e-2a94-11eb-011c-45d5675aa058
# ╟─0b8528d6-2a04-11eb-3868-a104698b3020
# ╟─7ef8e18a-2a6e-11eb-3f78-63ac63fe0a1f
# ╟─708eac10-2a78-11eb-1fce-2707e1d608ff
# ╟─90be85b4-2a6e-11eb-1ba0-cbb95854e12d
# ╟─599429c8-2a7c-11eb-2100-09cd187c0fe0
# ╟─9ebc0eac-2a6e-11eb-3b40-3ffa81a599fb
# ╟─258c6fe6-2a7c-11eb-248a-8f7c57573498
# ╟─c91efd58-2a6e-11eb-1609-8141a3b9a2df
# ╟─5fb42bb4-2a7c-11eb-061f-3199d78867c0
# ╟─0d74b710-2a04-11eb-32f8-47f7ab3b89c9
# ╟─daa00af4-2a6e-11eb-28c6-3dd2c48173b3
# ╟─13d2567e-2a79-11eb-1441-37d215be11c1
# ╟─e448285c-2a6e-11eb-0fe4-cd75a816a6d9
# ╟─671f304c-2a7c-11eb-2faa-17f5f7334bfb
# ╟─ecd24052-2a6e-11eb-0bf7-03d20ed504d0
# ╟─68240148-2a7c-11eb-1e7a-d5ae0e57a28c
# ╟─feba060e-2a6e-11eb-24e4-f52f26ad274c
# ╟─691a22b2-2a7c-11eb-1485-552728c5ea53
# ╠═5593fca8-2a9d-11eb-0dfd-d363c3e00dbb
# ╟─09b40cb4-2a6f-11eb-1847-431c3326a26f
# ╟─6a370458-2a7c-11eb-011e-fb6cefefed75
# ╟─185a1fe2-2a6f-11eb-3f50-c7566b28b458
# ╟─273e5c96-2a79-11eb-31a2-69bd6fc70804
# ╟─6c0f37fa-2a7c-11eb-266d-39038ad6c0c6
# ╟─00a86d40-2a79-11eb-2b91-95541f56c302
