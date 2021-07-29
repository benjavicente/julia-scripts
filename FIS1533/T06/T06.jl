### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 42e2dd78-3571-11eb-215b-a1b999eb5462
begin
	using Printf
	using Unitful, Unitful.DefaultSymbols, UnitfulRecipes
	using PlutoUI
	using Plots
	# LocalResource
	md"# Desarrollo Tarea 06"
end

# ╔═╡ a0844778-3571-11eb-0e5c-e7021a7f8cc3
md"""
FIS1533 Electricidad y Magnetismo\
Benjamín Vicente - 4 de diciembre 2020
"""

# ╔═╡ a2da34ba-3571-11eb-17b1-0bf19a1ac2d0
md"## Pregunta 1"

# ╔═╡ eb6991b2-3571-11eb-1a6e-6d3bccfe518a
md"""
Una barra cilíndrica metálica (``PQ``) de longitud ``l``, sección
transversal ``A``, densidad de masa ``\rho_m`` y resistencia ``R``
se desliza por dos rieles metálicos sin fricción en una zona donde
hay un campo magnético uniforme ``\vec{B} = B_0\hat{y}`` (perpendicular
al plano horizontal), tal como se muestra en la figura. Si en el instante
``t = 0``, la barra se mueve en la dirección ``+x`` con una velocidad
``v_0``, calcule:

(Considere que los rieles tienen una resistencia eléctrica despreciable
y que la longitud ``l`` de la barra es igual a la distancia entre los rieles.)
"""

# ╔═╡ 7a71d222-3572-11eb-32db-3da6226804cf
LocalResource("fig1.png", :width => 400)

# ╔═╡ 4cf210da-3572-11eb-02eb-8d43a4eb5eee
md"- La magnitud y dirección de la corriente inducida en la barra." 

# ╔═╡ 525984a2-3579-11eb-37a2-f56d6f1f663a
md""" **Desarrollo**


Primero, la fem inducida por el movimiento de la barra es:

```math
\epsilon = - Blv
```

y la corriente generada por esta es:

```math
I = \dfrac{|\epsilon|}{R} = \dfrac{Blv}{R}
```

por regla de la mano derecha, la dirección, mirada desde
arriba (``+y``) es en sentido horario. 
"""

# ╔═╡ 59889be8-3572-11eb-30fb-e3438e044d18
md"- La velocidad de la barra en función del tiempo." 

# ╔═╡ 5c667fa4-3579-11eb-3bdc-a3a159aba10f
md""" **Desarrollo**


La fuerza que ejerce el calpo magnético sobre la barra está dada por:

```math
F_B = I \int ds \times B
```

por lo tanto:

```math
F_B = m \dfrac{dv}{dt} = - IlB
```

remplazando ``I`` por la expésión obtenida anteriormente:

```math
m \dfrac{dv}{dt} = - \dfrac{Blv}{R}lB = - \dfrac{B^2l^2v}{R}
```

al despejar ``v``, queda:

```math
\dfrac{dv}{v} = - \left( \dfrac{B^2l^2}{mR} \right) dt
```

integrando:

```math
\left[\ln(x)\right]_{v_0}^v = - \left( \dfrac{B^2l^2}{mR} \right) t
```

```math
\ln\left(\dfrac{v}{v_0}\right) = - \left( \dfrac{B^2l^2}{mR} \right) t
```

```math
v = v_0 \exp\left[ -t \left( \dfrac{B^2l^2}{mR} \right) \right]
```

remplazando ``m = Al\rho_m``:

```math
v = v_0 \exp\left[ -t \left( \dfrac{B^2l}{A\rho_m R} \right) \right]
```

"""

# ╔═╡ 613aeefe-3572-11eb-321e-abf12895c4db
md"- La potencia eléctrica disipada en la barra."

# ╔═╡ 5d5aaf5c-3579-11eb-06a7-298818d82b96
md""" **Desarrollo**

La potencia es:

```math
P = F \times v
```

remplazando (y cambiando el símbolo ya que es la potencia _disipada_):

```math
P = IlB  v_0 \exp\left[ -t \left( \dfrac{B^2l}{A\rho_m R} \right) \right]
```

también se puede remplazar con las dos primeras expresiones de este ejercicio:

```math
P = IlBv = \dfrac{(Blv)^2}{R} = \dfrac{\epsilon^2}{R}
```
"""

# ╔═╡ 661f539c-3572-11eb-16e8-c1f22741b0e6
md"- La tasa de disminución de la energía cinética de la barra."

# ╔═╡ 5ec67c60-3579-11eb-232d-9d5139b560ca
md""" **Desarrollo**

La tada de disminución de la energía cinética está dada por:

```math
\dfrac{d}{dt} E_c =  \dfrac{d}{dt} \dfrac{m v^2}{2} = mv \dfrac{dv}{dt} = F_B v
```

como ``P = F \times v``, se tiene que:

```math
\dfrac{d}{dt} E_c = F_B v = \dfrac{P}{v} v = P
```
"""

# ╔═╡ c46856ac-3571-11eb-198d-3df08f7114a0
md"## Pregunta 2"

# ╔═╡ 936e463c-3572-11eb-275e-0d391878409f
md"""
Considere dos espiras conductoras circulares concéntricas, de radios
``a`` y ``b``, tal que ``b \gg a``. En el instante ``t = 0`` ambas
espiras coinciden en el plano ``xy``, y la espira de radio ``b`` se
mantiene en reposo mientras que la espira de radio ``a``, de resistencia
``R``, gira alrededor de su diámetro que coincide con el eje ``x`` con
velocidad angular constante ``\omega``. Suponga además que una corriente
constante ``I`` circula en la espira de radio ``b``, produciendo un campo
magnético uniforme en la región donde se encuentra la espira de radio ``a``.
"""

# ╔═╡ 1847c0a0-3577-11eb-061b-9134f02db26e
LocalResource("fig2.png", :width => 400)

# ╔═╡ dbf12a78-3572-11eb-05ce-d5c8029cd4af
md"""
- Determine la corriente ``I_a`` inducida en la espira de radio a,
  despreciando los efectos de autoinducción
"""

# ╔═╡ 7cc24b7a-3579-11eb-0fec-8f3ece17dd5b
md""" **Desarrollo**

Se tiene que:

```math
B = \dfrac{\mu_0 I}{4π} \int \dfrac{d\vec{l} \times \hat{d}}{d^2}
```

```math
\Phi_{1,2} = \oint \vec{B}_1 \cdot d\vec{A}_2
```

```math
\epsilon = - N\dfrac{d\Phi_B}{dt}
```

```math
I = \dfrac{|\epsilon|}{R}
```

donde ``N`` es el número de espiras (``N=1``), ``d`` la distancia.

Con la primera ecuación, se obtiene:

```math
B = \dfrac{\mu_0 I_b}{4π} \int_0^{2\pi} \dfrac{bd\theta\hat{z}}{b^2}
  = \dfrac{\mu_0 I_b}{2b} \hat{z}
```

donde ``\hat{z}`` es en dirección hacia afuera.


El flujo para las dos espiras:

```math
\Phi_{b,a} = \oint \vec{B}_b \cdot d\vec{A}_a
           = \dfrac{\mu_0 I_b}{2b} \pi a^2 \sin(\theta)
```

es ``\sin(\theta)`` ya que el producto punto cambia a medida que el
area va girando, e inicialmente la direción del camo y ``dA`` son perperndiculares.

```math
\epsilon = - \dfrac{d\Phi_{b,a}}{dt}
         = - \dfrac{d}{dt} \left(\dfrac{\mu_0 I_b}{2b} \pi a^2 \sin(\theta)\right)
         = - \dfrac{\mu_0 I_b}{2b} \pi a^2 \cos(\theta) \dfrac{d\theta}{dt}
         = - \dfrac{\mu_0 I_b}{2b} \pi a^2 \cos(\theta) \omega
```

por lo tanto:

```math
I_a = \dfrac{\mu_0 I_b \pi a^2 \cos(\theta) \omega}{2bR}
``` 
"""

# ╔═╡ eb7d0f70-3572-11eb-079b-a347d0215dc1
md"""
- Determine la potencia disipada en la espira de radio ``a``
  a través de su resistencia.
"""

# ╔═╡ 7f93967e-3579-11eb-3232-7bc432d9e5ff
md""" **Desarrollo**

Con

```math
P = \dfrac{\epsilon^2}{R}
```

```math
P = \dfrac{\mu_0^2 {I_b}^2 \pi^2 a^4 \cos(\theta)^2 \omega^2}{4 b^2  R^2}
```

"""

# ╔═╡ fc2643be-3572-11eb-3d64-d3a11dafa13a
md"""
- Determine el torque necesario para mantener la espira de radio ``a``
  rotando con velocidad angular ``\omega``.
"""

# ╔═╡ 838ee6fc-3579-11eb-19a4-c1087a510f93
md""" **Desarrollo**


Con:

```math
F = I\vec{l} \times \vec{B}
```

Inicialmente ``\vec{l}`` y ``\vec{B}`` están perpendiculares, a si que:

```math
F = I_a l_a B \cos(\theta) = \dfrac{I_a \pi \mu_0 I_b \cos(\theta)}{b} \hat{z}
```

```math
\tau = F \times d = \dfrac{I_a \pi \mu_0 I_b \cos(\theta)^2 d}{b} 
```
"""

# ╔═╡ 11f960b8-3573-11eb-01c0-d3181cd98121
md"""
- Considere ahora el caso en que la espira de radio ``a`` está en reposo
  sobre el plano ``xy``, con una corriente constante ``I`` circulando en
  ella, mientras que la espira de radio ``b`` gira sobre su diámetro que
  coincide con el eje ``x`` con velocidad angular constante ``\omega``.
  Determine la fuerza electromotriz inducida en la espira de radio ``b``,
  despreciendo los efectos de autoinducción.
"""

# ╔═╡ 86491eee-3579-11eb-3b52-1d0fa0580e39
md""" **Desarrollo**



"""

# ╔═╡ c7e85070-3571-11eb-1c44-e7dcb32ff8bc
md"## Pregunta 3"

# ╔═╡ b87d7cee-3573-11eb-3d28-b17a5ecd3499
begin
	largo = 20cm
	radio = 5mm
	N_vueltas = 10_000
	χₘ = -9.1 * 10^-6
	I = 10A
	μ₀ = 4π*10^(-7)*H/m 
end;

# ╔═╡ 3fb8b9ea-3573-11eb-3458-37a517354dbf
md"""
Considere un solenoide de largo ``L = ``$(largo) y radio ``R =`` $(radio),
fabricado con un alambre esmaltado (aislado eléctricamente) tal que
el número de vueltas es ``N =`` $(N_vueltas). Si este solenoide es sumergido
completamente en agua, que es un medio diamagnético con susceptibilidad
magnética ``\chi_m = `` $(@sprintf("%1.0E",χₘ)), y se le hace circular una
corriente ``I =`` $(I), determine:

- La intensidad de campo magnético ``H`` al interior del solenoide.
- El campo magnético ``B`` al interior del solenoide.
- La magnetización ``M`` del agua que está en el interior del solenoide.
"""

# ╔═╡ 8c7895ba-3579-11eb-3a49-d7d994cd66f2
md""" **Desarrollo**

Se tiene que:

```math
B \equiv \mu_0 (H + M)
```

y que:

```math
M \equiv \chi H
```

El campo magnético dentro de un solinoide ideal (``L \gg R``) es:

```math
B = \mu_0 \dfrac{N}{l} I
```

se puede aproximar el solinoide a uno ideal ya que $largo ≫ $radio
"""

# ╔═╡ e1058e4a-357d-11eb-0f91-45d8e14a5364
@assert largo/radio > 10 "No se puede considerar como solinoide ideal"

# ╔═╡ 5cc43e76-357b-11eb-1bf6-bf3ffa1ebfa0
campo_B = uconvert(T, μ₀*(N_vueltas / largo) * I)

# ╔═╡ eb2229e6-3580-11eb-2182-efb6a9367e87
md"""
Remplazando ``M`` se tiene que:
``\dfrac{B}{\mu_0(1 + \chi)} = \dfrac{NI}{l(1 + \chi)} = H``
"""

# ╔═╡ b98e6126-3577-11eb-0f6e-6378c9381030
intensidad_campo_H =  uconvert(A/m, (N_vueltas * I) / (largo * (1 + χₘ)))

# ╔═╡ 9650df5e-3581-11eb-167e-193d9c821d35
magnetización_M = intensidad_campo_H * χₘ

# ╔═╡ 12692144-3577-11eb-1111-bbc0d18fdcc2
html"<style>img {display: block;margin: 0 auto;}</style>"

# ╔═╡ Cell order:
# ╟─42e2dd78-3571-11eb-215b-a1b999eb5462
# ╟─a0844778-3571-11eb-0e5c-e7021a7f8cc3
# ╟─a2da34ba-3571-11eb-17b1-0bf19a1ac2d0
# ╟─eb6991b2-3571-11eb-1a6e-6d3bccfe518a
# ╟─7a71d222-3572-11eb-32db-3da6226804cf
# ╟─4cf210da-3572-11eb-02eb-8d43a4eb5eee
# ╟─525984a2-3579-11eb-37a2-f56d6f1f663a
# ╟─59889be8-3572-11eb-30fb-e3438e044d18
# ╟─5c667fa4-3579-11eb-3bdc-a3a159aba10f
# ╟─613aeefe-3572-11eb-321e-abf12895c4db
# ╟─5d5aaf5c-3579-11eb-06a7-298818d82b96
# ╟─661f539c-3572-11eb-16e8-c1f22741b0e6
# ╟─5ec67c60-3579-11eb-232d-9d5139b560ca
# ╟─c46856ac-3571-11eb-198d-3df08f7114a0
# ╟─936e463c-3572-11eb-275e-0d391878409f
# ╟─1847c0a0-3577-11eb-061b-9134f02db26e
# ╟─dbf12a78-3572-11eb-05ce-d5c8029cd4af
# ╟─7cc24b7a-3579-11eb-0fec-8f3ece17dd5b
# ╟─eb7d0f70-3572-11eb-079b-a347d0215dc1
# ╟─7f93967e-3579-11eb-3232-7bc432d9e5ff
# ╟─fc2643be-3572-11eb-3d64-d3a11dafa13a
# ╟─838ee6fc-3579-11eb-19a4-c1087a510f93
# ╟─11f960b8-3573-11eb-01c0-d3181cd98121
# ╟─86491eee-3579-11eb-3b52-1d0fa0580e39
# ╟─c7e85070-3571-11eb-1c44-e7dcb32ff8bc
# ╠═b87d7cee-3573-11eb-3d28-b17a5ecd3499
# ╟─3fb8b9ea-3573-11eb-3458-37a517354dbf
# ╟─8c7895ba-3579-11eb-3a49-d7d994cd66f2
# ╠═e1058e4a-357d-11eb-0f91-45d8e14a5364
# ╠═5cc43e76-357b-11eb-1bf6-bf3ffa1ebfa0
# ╟─eb2229e6-3580-11eb-2182-efb6a9367e87
# ╠═b98e6126-3577-11eb-0f6e-6378c9381030
# ╠═9650df5e-3581-11eb-167e-193d9c821d35
# ╟─12692144-3577-11eb-1111-bbc0d18fdcc2
