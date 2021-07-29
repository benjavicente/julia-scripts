### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ d9be5fa8-1d1e-11eb-31dd-e99d8302febf
begin
    using Unitful, Unitful.DefaultSymbols
    using PlutoUI, Plots
    function show_svg(svg_path)
		open(svg_path) do f
			PlutoUI.Show(
				MIME"image/svg+xml"(),
				repr(MIME"image/svg+xml"(), read(f, String))
			)
		end
	end
	# Título
	md"# Resumen T04"
end

# ╔═╡ 9b42e7fc-1e28-11eb-1a88-2daf0dcf1199
md"## Recordatorio"

# ╔═╡ a5070336-1e28-11eb-313a-31124f49dedb
md"
La capacitancia de un dondesnador está dado por:

```math
C ≡ \dfrac{Q}{ΔV}
```
La capacitancia se suma en paralelo y en serie se suma inversamente.

La consante de permitividad en el vacio es 
$\epsilon_0 = \dfrac{1}{4 \pi k} = 8.85 \times 10^{-12} \frac{C^2}{Nm^2}$

La carga de un electron se aproxima a $1.6 \times 10^{-19} C$

En un plano, un $\times$ incida que el vector entra y un $\cdot$ que el vector sale.
"

# ╔═╡ f775f740-1d1e-11eb-05b6-cf428676980d
md"## Resistencia y temperatura" 

# ╔═╡ f862c180-1d21-11eb-3921-8745f4fffcf8
md"
La resistividad de un material varia aproximadamente linealmente acorde
de la expresión:

```math
\rho = \rho_0 [1 + \alpha (T - T_0)]
```

donde $\alpha$ es el coeficiente térmico de resistividad.

Dado que la resistencia e sproporcinal, tambien se tiene que:

```math
R = R_0 [1 + \alpha (T - T_0)]
```
"

# ╔═╡ 909b3914-1d22-11eb-200e-1bf0e8453b8d
md"### Superconductores"

# ╔═╡ 978b6ba2-1d22-11eb-2571-6fad46019175
md"
Materiales cuya resistencia cae a 0 cuando se encuentran en
una temperatura crítica $T_c$
"

# ╔═╡ e6982e76-1d22-11eb-157a-f573c26e77b3
md"### Instrumentos eléctricos de medición"

# ╔═╡ a50751ec-1d24-11eb-152c-d1ac38eda900
md"
- Aperímetro: Mide la corriente ($A$) en serie
- Voltímetro: Mide la diferencia de potencial ($V$) en paralelo
- Galvanómetro: Mide el campo magnético, usado internamente por
  el amperímetro y el voltimero
"

# ╔═╡ 0b014600-1d26-11eb-0467-8785bc168c41
md"## Circuitos Resistencia-Condensador"

# ╔═╡ 38fb29e8-1d28-11eb-3a30-054d76311a61
show_svg("fig1.svg")

# ╔═╡ 3c729fc0-1d28-11eb-0b67-af6b669eb441
md"Al iniciar con un condensador inicialmente cargado, se tiene que:

```math
\epsilon - \dfrac{q}{C} - IR = 0
```

Cuando $t = 0$, se tiene que $q = 0 \rightarrow I_0 = \dfrac{\epsilon}{R}$

Cuaddo $t \rightarrow \infty$, se tiene que $I = 0 \rightarrow q = C \epsilon$

Dado $I = \dfrac{dq}{dt}$, se tiene (EDO):

```math
\dfrac{dq}{dt} = \dfrac{\epsilon}{R} - \dfrac{q}{RC}
```

Integrando, se obtiene:

```math
\int_0^q \dfrac{dq}{q - C \epsilon} = - \dfrac{1}{RC} \int_0^t dt 
```

```math
\ln \left( \dfrac{q - C \epsilon}{- C \epsilon} \right) = - \dfrac{t}{RC}
```


```math
q(t) = C \epsilon \left( 1 - e ^{-t / RC} \right)
```

```math
I(t) = \dfrac{\epsilon}{R}  e ^{-t / RC}
```
"

# ╔═╡ 11205dcc-1e26-11eb-2127-9ba1f494f8d8
md"
+ C = $(@bind C₁ Slider(0.1:0.1:3, show_value=true))
+ R = $(@bind R₁ Slider(0.1:0.1:3, show_value=true))
"

# ╔═╡ ff112b02-1e2a-11eb-1409-c1df55930d06
begin
	ϵ = 8.8541878176 * 10^(-12)
	t = Array(0:0.1:5)
	q(t) = C₁*ϵ*(1 - ℯ^(-t/(R₁*C₁)))
	I(t) = ϵ/R₁ * ℯ^(-t/(R₁*C₁))
	plot(t, q.(t), label=raw"$q$")
	plot!(t, I.(t), label=raw"$I$")
end

# ╔═╡ 76b7ff22-1e3e-11eb-2a39-4f7b018a7841
md"
El proceso en el que el condensador se descarga con canga inicial $q_0$, se tiene que:

```math
\dfrac{dq}{dt} = - \dfrac{1}{RC}dt
```

```math
\ln\left(\dfrac{q}{q_0} \right) = - \dfrac{t}{RC}
```
"

# ╔═╡ 96bf1b0c-1e40-11eb-0227-2d79c34aae98
md"## Campo magnético"

# ╔═╡ 82861aba-1eaa-11eb-2b10-bf106dc22a24
md"
La fuerza que ejerce un campo magnético $\vec{B}$ es:

```math
\vec{F}_B = q \vec{v} \times \vec{B}
```

Su magnitud es:

```math
F_B = |q| v B \sin(\theta)
```

La unidad del campo magnético es el tesla ($T$), que es:

```math
1 T = \dfrac{N}{C \cdot m/s}
```
"

# ╔═╡ 0d92d2de-1ead-11eb-08bf-f5cee68965c6
md"### Campo en movimiento circular"

# ╔═╡ 2a80d650-1ead-11eb-1bb8-c9fa922a4a9e
md"
Cando el movimiento es circular, la fuerza es hacia dentro del movimiento
y la velocidad tangente al movimiento circular.


```math
F_B = qvB = \dfrac{mv^2}{r}
```

Donde la velocidad agunlar es $\omega = \dfrac{v}{r} = \dfrac{qB}{m}$
y el periodo es $T = \dfrac{2\pi}{\omega} =  \dfrac{2 \pi m}{qB}$.
"

# ╔═╡ 290b3ce4-1eae-11eb-0bd3-d55219ea3b63
md"### Trabajo y energía"

# ╔═╡ 32b6d078-1eae-11eb-3446-b1dd1426ad61
md"
Como el $\vec{F}_B$ es perpendicular a $\vec{v}$, el campo magnético
**no realiza trabajo**.
El campo magnético altera la dirección de $\vec{v}$, pero no su módulo,
por lo que no altera su energía cinética.
"

# ╔═╡ 28ca6308-1eaf-11eb-29c8-373c43323ff6
md"### Campo magnético y eléctrico"

# ╔═╡ 3be5cb6c-1eaf-11eb-1e12-c584d9e95f66
md"
La fuerza neta neta sobre una partícula se le denomina
fuerza de Lorentz:

```math
\vec{F} = q\vec{E} + q\vec{v} \times \vec{B}
```
"

# ╔═╡ a499d578-1ec2-11eb-1794-39d5661e8da4
md"### En un alambre"

# ╔═╡ b6100c46-1ec2-11eb-29b6-e588f77a5c34
md"""
La fuerza total actuando en un trozo de alambre está dado por:

```math
\vec{F}_B = (q \vec{v} \times \vec{B} ) nAL
```

donde $A$ es el área del alambre, $L$ es el largo y $n$ el número de portadores
de carga por unidad de volumen.
Ya que $I = nqvA$, se tiene que:

```math
\vec{F}_B = I \vec{L} \times \vec{B}
```

donde $L$ es el vector en dirección a la corriente
con magnitud la longitud del segmento.
para un segmento de longitud $ds$ se tiene que:

```math
\vec{F}_B = I \int_a^b ds \times B
```
"""

# ╔═╡ a32a29d8-1ec5-11eb-103a-0f100b7b47bc
md"## Torque y momento dipolar"

# ╔═╡ 99eec0c0-1ec7-11eb-36f7-4d0505bde229
md"
El torque se define como:

```math
\tau = \vec{F} \times \vec{r}
```

donde $\vec{r}$ es la posición relativa al centro de rotación.
"

# ╔═╡ 473e81d0-1ec7-11eb-2124-350f79af0811
show_svg("fig2.svg")

# ╔═╡ 64a79982-1ec9-11eb-1fac-5facba227a89
md"""
Considerando el centro de rotación una linea vertical centrana a la espira,
y el angulo que forma el campo $B$ con la espira de área $A$ es $\theta$:

```math
\tau = Iab \sin(\theta)
```

```math
\tau = I \vec{A} \times \vec{B}
```
"""

# ╔═╡ 60a3c3b2-1eca-11eb-307f-b9cce68626aa
md"### Momento dipolar"

# ╔═╡ 6e0ec7e0-1eca-11eb-02d2-21d36a85bc59
md"
Se puede expresar el torque ejercido sobre una espira en un campo magnetico $B$ como:

```math
\tau = \mu \times B
```

Donde el producto $\mu = IA$ es definido como el **momento dipolar magnético**
"

# ╔═╡ c7638216-1f03-11eb-2944-5736c9f6eba7
md"### Bobina"

# ╔═╡ d2a8ff36-1f03-11eb-0478-abc175de674c
md"""
Un embobinado consiste en alambre enrollado de ta manera si fueran como
$N$ espiras iguales. Por lo tanto, el torque neto está dado por:

```math
\tau = N \vec{\mu}_{\text{espira}} \times \vec{B}
```
"""

# ╔═╡ 7c0f9cea-1f04-11eb-1c21-3910b75b183b
md"### Energía potencial"

# ╔═╡ 87afacf2-1f04-11eb-337f-e77ab3525eb1
md"""
Se puede definir la energía potencial del momento dipolar magnético como:

```math
U = - \mu \cdot B
```
"""

# ╔═╡ Cell order:
# ╟─d9be5fa8-1d1e-11eb-31dd-e99d8302febf
# ╟─9b42e7fc-1e28-11eb-1a88-2daf0dcf1199
# ╟─a5070336-1e28-11eb-313a-31124f49dedb
# ╟─f775f740-1d1e-11eb-05b6-cf428676980d
# ╟─f862c180-1d21-11eb-3921-8745f4fffcf8
# ╟─909b3914-1d22-11eb-200e-1bf0e8453b8d
# ╟─978b6ba2-1d22-11eb-2571-6fad46019175
# ╟─e6982e76-1d22-11eb-157a-f573c26e77b3
# ╟─a50751ec-1d24-11eb-152c-d1ac38eda900
# ╟─0b014600-1d26-11eb-0467-8785bc168c41
# ╟─38fb29e8-1d28-11eb-3a30-054d76311a61
# ╟─3c729fc0-1d28-11eb-0b67-af6b669eb441
# ╟─11205dcc-1e26-11eb-2127-9ba1f494f8d8
# ╟─ff112b02-1e2a-11eb-1409-c1df55930d06
# ╟─76b7ff22-1e3e-11eb-2a39-4f7b018a7841
# ╟─96bf1b0c-1e40-11eb-0227-2d79c34aae98
# ╟─82861aba-1eaa-11eb-2b10-bf106dc22a24
# ╟─0d92d2de-1ead-11eb-08bf-f5cee68965c6
# ╟─2a80d650-1ead-11eb-1bb8-c9fa922a4a9e
# ╟─290b3ce4-1eae-11eb-0bd3-d55219ea3b63
# ╟─32b6d078-1eae-11eb-3446-b1dd1426ad61
# ╟─28ca6308-1eaf-11eb-29c8-373c43323ff6
# ╟─3be5cb6c-1eaf-11eb-1e12-c584d9e95f66
# ╟─a499d578-1ec2-11eb-1794-39d5661e8da4
# ╟─b6100c46-1ec2-11eb-29b6-e588f77a5c34
# ╟─a32a29d8-1ec5-11eb-103a-0f100b7b47bc
# ╟─99eec0c0-1ec7-11eb-36f7-4d0505bde229
# ╟─473e81d0-1ec7-11eb-2124-350f79af0811
# ╟─64a79982-1ec9-11eb-1fac-5facba227a89
# ╟─60a3c3b2-1eca-11eb-307f-b9cce68626aa
# ╟─6e0ec7e0-1eca-11eb-02d2-21d36a85bc59
# ╟─c7638216-1f03-11eb-2944-5736c9f6eba7
# ╟─d2a8ff36-1f03-11eb-0478-abc175de674c
# ╟─7c0f9cea-1f04-11eb-1c21-3910b75b183b
# ╟─87afacf2-1f04-11eb-337f-e77ab3525eb1
