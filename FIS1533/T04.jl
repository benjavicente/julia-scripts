### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# ╔═╡ 7312c8ee-1f7f-11eb-3c69-efe4c552fc6f
begin
    using Unitful, Unitful.DefaultSymbols
    using PlutoUI
	using Plots
    function show_svg(svg_path)
		open(svg_path) do f
			PlutoUI.Show(
				MIME"image/svg+xml"(),
				repr(MIME"image/svg+xml"(), read(f, String))
			)
		end
	end
	md"""
	# Desarrollo Tarea 04

	FIS1533 Electricidad y Magnetismo\
	Benjamín Vicente - 6 de noviembre 2020
	"""
end

# ╔═╡ 7fa2f5fc-1f7f-11eb-0fbd-3daeccf4b62c
md"## Pregunta 1"

# ╔═╡ ddbedae8-1f7f-11eb-3872-c52fb4778c00
begin
	C₁ = 10μF
	R₁ = 2MΩ
	ϵ  = 100V
	fact_carga_1 = 1//8
	fact_carga_2 = 99//100
end;

# ╔═╡ 98936a1a-1f7f-11eb-35a6-3be422f32a92
md"""
a) Un condensador de $C₁, inicialmente descargado, y un resistor de
   $R₁ están conectados en serie con una fuente de $ϵ. Calcule:
"""

# ╔═╡ 17fe9822-1faf-11eb-3d25-79d95f489aa1
show_svg("T04-fig_0.svg")

# ╔═╡ c6f9d2c2-1f7f-11eb-050c-db0da9f70c31
md"""
1. la corriente inicial en el condensador
"""

# ╔═╡ 5286c0e6-1faf-11eb-0cbb-d14b88b758f3
md"""
**Desarrollo**

Se tiene que la ecuación de el circuito es:

```math
\epsilon - \dfrac{q}{C} - IR = 0
```

como $q_0 = 0$, se tiene que:

```math
I_0 = \dfrac{\epsilon}{R}
```
"""

# ╔═╡ 53efc3ee-1fb2-11eb-02cd-71141e62cb91
I₀ = uconvert(μA, ϵ//R₁);

# ╔═╡ f9f28f88-1fb2-11eb-074a-35576293663a
md"por lo que la corriente inicial es **$I₀**"

# ╔═╡ 3421050a-1f80-11eb-2e24-bd2d4aa04462
md"""
2. la corriente cuando el condensador tiene una carga igual a un
   octavo ($fact_carga_1) de la carga final (máxima)
"""

# ╔═╡ ecef4740-1fb2-11eb-1bc4-014af3f5f428
md"""
**Desarrollo**

La carga máxima ocurre cuando $I$ es mínimo ($\approx 0$), por lo tanto:

```math
q_{\text{final}} = \epsilon C
```
"""

# ╔═╡ 9ba3b024-1fbf-11eb-3a3e-4bf2ab6d8ea8
q_final = ϵ * C₁;

# ╔═╡ f702af1c-1fb3-11eb-3db1-6785422892c0
q₁ = uconvert(mC, q_final * fact_carga_1);

# ╔═╡ cf03341a-1fb4-11eb-12d5-43e7c907d651
md"Por lo tanto, se busca la corriente cuando la carga es $q₁"

# ╔═╡ 4bcf8396-1fb6-11eb-04f3-0382c752d448
md"""
Usando nuevamente la formula:

```math
\epsilon - \dfrac{q}{C} - IR = 0
```

se depseja I:

```math
I = \dfrac{\epsilon C - q}{CR}
```
"""

# ╔═╡ 8606ed18-1fb6-11eb-2c98-0151c6cb0285
I₁ = uconvert(μA, (ϵ * C₁ - q₁) / (C₁ * R₁));

# ╔═╡ e91e897e-1fb6-11eb-25a9-cdd1f20f265b
md"por lo que la corriente cuando llega a esa carga es **$I₁**"

# ╔═╡ 4c137b02-1f80-11eb-2749-c308001232ad
md"""
3. el tiempo característico del circuito RC
"""

# ╔═╡ 94be014c-1fb7-11eb-3528-cf96f26349e2
md"""
**Desarrollo**

El tiempo de característico se define como


```math
\tau \equiv RC
```
"""

# ╔═╡ f7309650-1fb7-11eb-1c32-c798a1737e53
τ₁ = uconvert(s, R₁*C₁);

# ╔═╡ 10234d88-1fb8-11eb-08be-7bb56369f2f2
md"el cual es igual a **$τ₁**."

# ╔═╡ 52317bf4-1f80-11eb-03ab-eda307bdc0e8
md"""
4. el tiempo en que ha aumentado la carga en el condensador en
   un factor 99% de su valor final (``\ln 100 \approx 4.6``)
"""

# ╔═╡ 9f81114a-1fb8-11eb-1999-01133a583ada
md"**Desarrollo**"

# ╔═╡ d6dfea4e-1fb8-11eb-0e47-b51ce471179d
q₂ = uconvert(mC, q_final * fact_carga_2);

# ╔═╡ eea5031c-1fb8-11eb-1cf2-a7155944aae0
md"La carga que se busca es $q₂" 

# ╔═╡ fd6bed88-1fb9-11eb-02a2-afda454a6e25
md"""
Para obtener el tiempo, se nesesita resolver la ecuación diferencial:

```math
\epsilon - \dfrac{q}{C} - \dfrac{dq}{dt}R = 0
```

despejando ``\dfrac{dq}{dt}``:

```math
\dfrac{dq}{dt} = \dfrac{\epsilon C - q}{CR}
```

dejando los diferenciales en cada lado:

```math
\dfrac{1}{\epsilon C - q} dq = \dfrac{1}{CR} dt
```

integrando:

```math
\int_0^{q_2} \dfrac{1}{\epsilon C - q} dq = \dfrac{1}{CR} \int_0^{t_2} dt
```

```math
\left[ - \ln(q - \epsilon C)  \right]_0^{q_2} = \dfrac{t_2}{CR}
```

```math
\ln (\epsilon C) - \ln (\epsilon C - q_2) = \dfrac{t_2}{CR}
```

por lo tanto:

```math
t_2 = CR(\ln (\epsilon C) - \ln (\epsilon C - q_2))
```
"""

# ╔═╡ f321b46e-1fbb-11eb-37b4-3ba5b33c8a2e
t₃ = uconvert( s, C₁*R₁*log((ϵ*C₁)/(ϵ*C₁ - q₂)) );

# ╔═╡ 77d31b70-1fbd-11eb-0070-d395d72942bf
md"el tiempo en el que llega a la proporción de carga inicial es **$t₃**" 

# ╔═╡ c191462c-1f83-11eb-2557-533ca421a9e4
md"""
5. El condensador (de $C₁) cargado ahora se descarga a
   través de la resistencia de $R₁.
   Calcule el tiempo necesario para que el condensador se
   descargue a la mitad de su carga inicial.
"""

# ╔═╡ eb3886e6-1fb9-11eb-1d44-bd32b8de18a3
md"""
**Desarrollo**

Asumo que ahora se elimina la fuente del circuito, quedando solo el condensador
y la resistencia. Por lo tanto, la ecuación inicial queda en:

```math
\dfrac{q}{C} + IR = 0
```

remplazando $I = \dfrac{dq}{dt}$:

```math
\dfrac{q}{C} = - \dfrac{dq}{dt} R
```

```math
\dfrac{1}{CR}dt = - \dfrac{dq}{q}
```

integrando:

```math
\dfrac{1}{CR}\int_0^{t₅}dt = -\int_{q_\text{final}}^{q_{\text{final}}/2}\dfrac{1}{q}dq
```

```math
\dfrac{t}{CR} = - \left[ \ln(q)\right]_{q_\text{final}}^{q_{\text{final}}/2}
```

```math
\dfrac{t}{CR} = \ln(q_{\text{final}}) - \ln(q_{\text{final}}/2)
```

```math
t = CR\ln(2)
```

"""

# ╔═╡ 2d8c0bec-1fbf-11eb-100a-c91990e460f2
t₅ = uconvert(s, C₁*R₁*log(2));

# ╔═╡ 930f191e-1fc9-11eb-1d9e-590153672775
md"Para que se descargue a la mitad, necesita **$t₅**"

# ╔═╡ ddd9e420-1fb9-11eb-223e-179a4900cf66
md"---"

# ╔═╡ 8c3ac560-1f7f-11eb-18d2-37ab35edde46
md"## Pregunta 2"

# ╔═╡ 6443dc0e-1f84-11eb-3d10-c7fd07f3981c
begin
	V₂ = 100V
	R₂ = 25Ω
	C₂ = 100μF
	d₂ = 100cm
end;

# ╔═╡ 99ba4e58-1f85-11eb-1701-f347e3571e18
show_svg("T04-fig_1.svg")

# ╔═╡ 884f4bdc-1f80-11eb-39f3-2f8a8822ff6f
md"""
El circuito mostrado en la figura es utilizado para medir la velocidad de una
bala con elementos de los siguientes valores: V₀ = $V₂, R = $R₂, C = $C₂, d = $d₂.

Inicialmente, el condensador está cargado, luego la bala corta el alambre $A$ desconectando la batería, y posteriormente corta el alambre $B$, dejando aislado
el condensador, cuya diferencia de potencial, una vez cortados ambos alambres,
es V₀/4.
"""

# ╔═╡ cc46095c-1f80-11eb-0013-bd9446dbba46
md"""
1. Calcular la diferencia de potencial en el condensador antes que la
   bala corte los alambres, suponiendo que la batería ha estado conectada
   durante largo tiempo.
"""

# ╔═╡ 7b6554a6-1f97-11eb-1b7e-99cc8d42f931
md"""**Desarrollo**

Considerando $I_1$ e $I_2$ como la corriente que está pasando en el capacitor y
la resistencia de la derecha, $V_c$ el potencial de la derecha y
$V_1$ es el potencial de arriba, se tiene que:

```math
I = I_1 + I_2
```

```math
V_0 = V_1 + V_c
```

```math
I_1 = \dot{q}_{c} = C \dot{V}_c 
```

```math
I_2 = \dfrac{V_c}{R} 
```

donde se tiene que despejar $V_c$. remplazando0 la ecuación (3) y (4) en la (1):

```math
I = C \dot{V}_c + \dfrac{V_c}{R} 
```

el potencial en la parte de arriba es $V_1 = I R$, remplazando esa expresión
en la ecuación (2) se obtiene:

```math
V_0 = \left( C \dot{V}_c + \dfrac{V_c}{R} \right) R + V_c
```

```math
V_0 = \dfrac{C \dot{V}_c}{R} + V_c + V_c
```

ya que $\dot{V}_c \approx 0$ ya que la batería ha estado conectado por
durante largo tiempo, se tiene que:

```math
V_0 = 2V_c
```
"""

# ╔═╡ cf5829ae-1f8f-11eb-1b39-79b1b5e17661
V_c = V₂/2;

# ╔═╡ d56d230c-1f97-11eb-142b-75801a4269a8
md"obteniendo que la diferencia de potencial en el condensador es **$V_c**"

# ╔═╡ 3b552f50-1f84-11eb-1468-a9ff8227a0cc
md"2. Determinar la velocidad de la bala."

# ╔═╡ 149431b8-1f98-11eb-3ce5-736da7db54bc
md"""
**Desarrollo**

El potencial eléctrico del condensador para de $V_0/2$ a $V_0/4$

Ya que:

```math
q_c = CV_c
```

se tiene que la relación entre la carga inicial $q_0$ y final $q_f$ es:

```math
\dfrac{q_0}{q_f} = \dfrac{ C \frac{V_0}{2}}{C \frac{V_0}{4} } = 2
```

Considerando el nuevo circuito cerrado formado por la resistencia y el condensador,
se tiene que:

```math
R I + \dfrac{q}{C} = 0
```

ya que $I = \dfrac{dq}{dt}$:

```math
R \dfrac{dq}{dt} = - \dfrac{q}{C}
```

```math
\dfrac{dq}{q} = - \dfrac{1}{CR} dt
```

integrando desde $0$ a un $t$ desconocido, se obtiene:

```math
\int_{q_0}^{q_f} \dfrac{dq}{q} = - \dfrac{1}{CR} \int_0^t dt
```

```math
\ln(q_f) - \ln(q_0) = - \dfrac{1}{CR} t
```

```math
CR \left( \ln \left(\dfrac{q_0}{q_f} \right) \right) =  t
```

remplazando por la proporción entre las cargas obtenida inicialmente, queda:

```math
CR \ln (2) =  t
```
"""

# ╔═╡ b366c834-1f9b-11eb-3ac7-95e206ef1da3
t₂ = uconvert(s, C₂ * R₂ * log(2));

# ╔═╡ 32d52722-1f9d-11eb-2f33-7367f7dfde80
md"por lo que el tiempo es **$t₂**."

# ╔═╡ f685d93e-1f9b-11eb-1948-db26b3345ab1
md"Como la distancia que recorrió la bala en $t$ es $d$, la velocidad es $d/t$"

# ╔═╡ d0bc06f6-1f9b-11eb-33da-8ffa8804479b
v₂ = uconvert(m/s, d₂/t₂);

# ╔═╡ 2c449b46-1f9c-11eb-292d-2f2a93942240
md"La velocidad de la bala, por lo tanto, es: **$v₂**"

# ╔═╡ 3ad2a26a-1f84-11eb-3e21-039cd9c2e09c
md"""
3. Graficar la corriente a través del condensador, en función del tiempo.
"""

# ╔═╡ 9961ab00-1f9d-11eb-0c80-d12421780432
md"""
**Desarrollo**

Se pide graficar $I = \dfrac{dq}{dt}$ con respecto a $t$.

Considerando la ecuación anterior:

```math
\ln(q_f) - \ln(q_0) = - \dfrac{1}{CR} t
```

pero considerando $q_f$ como una variable $q$, se despeja:

```math
q = q_0 e^{- t/CR }
```

derivando en $t$ se obtiene:

```math
I = \dfrac{dq}{dt} = \dfrac{- q_0}{CR} e^{- t/CR }
```

_Nota: como $I$ es negativo, quiere decir que el sentido es opuesto al planteado
inicialmente en la parte 1, va hacia arriba en vez de hacia abajo._

```math
I = \dfrac{q_0}{CR} e^{- t/CR }
```
"""

# ╔═╡ 01c4b0ba-1f86-11eb-120e-e567ffe9fef5
begin
	proyeccion(x) = (1A / (C₂*R₂)) * ℯ^(-x/(C₂*R₂))
	I(x) = x < t₂ ? proyeccion(x) : 0A/s
	tₙ = range(0s, stop=4t₂, length=400)
	plot(ustrip.(s, tₙ), ustrip.(A/s, I.(tₙ)), label="Corriente", color=:blue)
	plot!(ustrip.(s, tₙ),ustrip.(A/s, proyeccion.(tₙ)),
		  label="Corriente sin corte", line=:dot, color=:lightblue)
	vline!([ustrip(s, t₂)], label="Tiempo de corte", color=:red)
	xlabel!("Tiempo (s)")
	ylabel!("Corriente (I = A/s)")
end

# ╔═╡ Cell order:
# ╟─7312c8ee-1f7f-11eb-3c69-efe4c552fc6f
# ╟─7fa2f5fc-1f7f-11eb-0fbd-3daeccf4b62c
# ╠═ddbedae8-1f7f-11eb-3872-c52fb4778c00
# ╟─98936a1a-1f7f-11eb-35a6-3be422f32a92
# ╠═17fe9822-1faf-11eb-3d25-79d95f489aa1
# ╟─c6f9d2c2-1f7f-11eb-050c-db0da9f70c31
# ╟─5286c0e6-1faf-11eb-0cbb-d14b88b758f3
# ╠═53efc3ee-1fb2-11eb-02cd-71141e62cb91
# ╟─f9f28f88-1fb2-11eb-074a-35576293663a
# ╟─3421050a-1f80-11eb-2e24-bd2d4aa04462
# ╟─ecef4740-1fb2-11eb-1bc4-014af3f5f428
# ╠═9ba3b024-1fbf-11eb-3a3e-4bf2ab6d8ea8
# ╠═f702af1c-1fb3-11eb-3db1-6785422892c0
# ╟─cf03341a-1fb4-11eb-12d5-43e7c907d651
# ╟─4bcf8396-1fb6-11eb-04f3-0382c752d448
# ╠═8606ed18-1fb6-11eb-2c98-0151c6cb0285
# ╟─e91e897e-1fb6-11eb-25a9-cdd1f20f265b
# ╟─4c137b02-1f80-11eb-2749-c308001232ad
# ╟─94be014c-1fb7-11eb-3528-cf96f26349e2
# ╠═f7309650-1fb7-11eb-1c32-c798a1737e53
# ╟─10234d88-1fb8-11eb-08be-7bb56369f2f2
# ╟─52317bf4-1f80-11eb-03ab-eda307bdc0e8
# ╟─9f81114a-1fb8-11eb-1999-01133a583ada
# ╠═d6dfea4e-1fb8-11eb-0e47-b51ce471179d
# ╟─eea5031c-1fb8-11eb-1cf2-a7155944aae0
# ╟─fd6bed88-1fb9-11eb-02a2-afda454a6e25
# ╠═f321b46e-1fbb-11eb-37b4-3ba5b33c8a2e
# ╟─77d31b70-1fbd-11eb-0070-d395d72942bf
# ╟─c191462c-1f83-11eb-2557-533ca421a9e4
# ╟─eb3886e6-1fb9-11eb-1d44-bd32b8de18a3
# ╠═2d8c0bec-1fbf-11eb-100a-c91990e460f2
# ╟─930f191e-1fc9-11eb-1d9e-590153672775
# ╟─ddd9e420-1fb9-11eb-223e-179a4900cf66
# ╟─8c3ac560-1f7f-11eb-18d2-37ab35edde46
# ╠═6443dc0e-1f84-11eb-3d10-c7fd07f3981c
# ╟─99ba4e58-1f85-11eb-1701-f347e3571e18
# ╟─884f4bdc-1f80-11eb-39f3-2f8a8822ff6f
# ╟─cc46095c-1f80-11eb-0013-bd9446dbba46
# ╟─7b6554a6-1f97-11eb-1b7e-99cc8d42f931
# ╠═cf5829ae-1f8f-11eb-1b39-79b1b5e17661
# ╟─d56d230c-1f97-11eb-142b-75801a4269a8
# ╟─3b552f50-1f84-11eb-1468-a9ff8227a0cc
# ╟─149431b8-1f98-11eb-3ce5-736da7db54bc
# ╠═b366c834-1f9b-11eb-3ac7-95e206ef1da3
# ╟─32d52722-1f9d-11eb-2f33-7367f7dfde80
# ╟─f685d93e-1f9b-11eb-1948-db26b3345ab1
# ╠═d0bc06f6-1f9b-11eb-33da-8ffa8804479b
# ╟─2c449b46-1f9c-11eb-292d-2f2a93942240
# ╟─3ad2a26a-1f84-11eb-3e21-039cd9c2e09c
# ╟─9961ab00-1f9d-11eb-0c80-d12421780432
# ╟─01c4b0ba-1f86-11eb-120e-e567ffe9fef5
