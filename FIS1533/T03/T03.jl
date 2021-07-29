### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ fd8a65a2-14d4-11eb-1d08-1f273b61eba3
begin
    using Unitful, Unitful.DefaultSymbols
    using PlutoUI
    as_svg(x) = PlutoUI.Show(MIME"image/svg+xml"(), repr(MIME"image/svg+xml"(), x))
	# Título
md"# Desarrollo Tarea 03

FIS1533 Electricidad y Magnetismo\
Benjamín Vicente - 23 de octubre 2020"
end

# ╔═╡ 79069da0-14cd-11eb-08c9-9bcea31f0245
md"## Pregunta 1
Considere un condensador cilíndrico de largo $L$ formado por un
conductor cilíndrico sólido de radio $a$ y un cascarón cilíndrico
de radio $b$, ambos fijos en el espacio. Inicialmente el volumen
entre el conductor y el cascarón está completamente lleno con un
material de constante dieléctrica $\kappa$ (permitividad relativa),
situación en la cual el condensador fue cargado de tal manera que se
almacenó una carga $Q$ en el cascarón y una carga $-Q$ en el conductor
interior. Si en cierto instante un agente externo extrae la pieza de
material dieléctrico, de manera tal que queda la mitad de su largo
fuera del condensador (como se muestra en la figura) determine:
"

# ╔═╡ 380d972e-1561-11eb-07c5-513d7e9e9683
open("figura1.svg") do f
    as_svg(read(f, String))
end

# ╔═╡ 45ef08fa-1561-11eb-0f3f-1154cd3a3c77
md"Figura 1:
Extracción de un dieléctrico desde un condensador cilíndrico.
Considere que $a \ll L$ y $b \ll L$.
"

# ╔═╡ 5e773de0-14d3-11eb-2c14-cb1f543690f9
md"
i) La fuerza necesaria que debe realizar el agente externo para mantener el
dieléctrico en la posición mostrada en al figura.
"

# ╔═╡ 82533da2-1561-11eb-2284-31a60116fb72
md"**Desarrollo**


El sistema tendrá una energía potencial $U$, qué está dada por:

```math
U = \dfrac{Q^2}{2C}
```

además, el trabajo realizado por un agente externo por medio de una fuerza
se almacena como energía interna, por lo tanto:


```math
F_{\text{cond}} = - F_{\text{ext}}
= \dfrac{dW}{dx} = \dfrac{dU}{dx} = - \dfrac{Q^2}{2C^2} \dfrac{dC}{dx}
```

donde $C$ es la capacitancia dependiente de la posición del dieléctrico
y $Q$ es constante.

Para obtener $C$, se utiliza:

```math
C = \dfrac{Q}{|\Delta V|}
```

donde

```math
V = E \cdot L
```

Usando Ley de Gauss:

```math
\int_S \vec{E}d\vec{A} = \dfrac{q}{\epsilon_0}
```


se obtiene que:

```math
E = \dfrac{Q}{2 \pi r L \epsilon}
```

Ahora, $|\Delta V|$, de $a$ a $b$ es:

```math
|\Delta V| = \dfrac{Q}{2 \pi \epsilon} \left|\dfrac{1}{b} - \dfrac{1}{a}\right|
           = \dfrac{Q|a-b|}{2 \pi \epsilon ab}
           = \dfrac{Q(b-a)}{2 \pi \epsilon ab}
```

remplazando en $C$:

```math
C = \dfrac{2 \pi \epsilon ab}{b-a}
```

Esta ultima expresión es la capacitancia cuando un dieléctrico está completamente
dentro del capacitante. Para obtener la expresión considerando la parte que posee
aire y la parte del dieléctrico, se considerar como si fueran en paralelo y se suman:

```math
C = \dfrac{2 \pi \epsilon_0 \kappa ab}{b-a} \left(\dfrac{L-x}{L}\right)
+ \dfrac{2 \pi \epsilon_0 ab}{b-a} \left(\dfrac{x}{L}\right),
\text{ con } 0 \leq x \leq L 
```

ahora, se deriva esa expresión en $x$:


```math
\dfrac{dC}{dx}
= \dfrac{2 \pi \epsilon_0 ab}{b-a}\left(\dfrac{\kappa L - \kappa x +x}{L} \right) dx
= \dfrac{2 \pi \epsilon_0 ab}{b-a}\left(\dfrac{\kappa L + x(1-\kappa)}{L} \right) dx
```

```math
\dfrac{dC}{dx} = \dfrac{2 \pi \epsilon_0 ab}{(b-a)L} (1-\kappa)
```

remplazando $x$ en $C$ por la distancia desplazada $L/2$, se obtiene:

```math
C = \dfrac{2 \pi \epsilon_0 ab}{b - a} \left( \dfrac{\kappa + 1}{2} \right)
= \dfrac{\pi \epsilon_0 ab (\kappa + 1)}{b - a} 
```

Ahora se puede completar la segunda ecuación, obteniendo la fuerza:

```math
F_{\text{ext}} = \dfrac{Q^2}{
\left(
    \dfrac{\pi \epsilon_0 ab (\kappa + 1)}{b - a}
\right)^2}
\left(
    \dfrac{2 \pi \epsilon_0 ab}{(b-a)L} (1-\kappa)
\right)
```

simplificando:


```math
F_{\text{ext}} = \dfrac{2Q^2(b-a) (1-\kappa)}{\pi \epsilon_0 abL (\kappa + 1)^2}
```

"

# ╔═╡ b5b527ae-1585-11eb-080f-bf467998763d
(C^2 * m)/( (C^2/(N*m^2)) * m^3 )  # Ver si las unidades calzan

# ╔═╡ 313ed70a-155c-11eb-0fec-39cb8d57ba2a
md"---"

# ╔═╡ 6cad6510-14d3-11eb-1409-372992f4e59a
md"
ii) El trabajo realizado por el agente externo para llevar el
dieléctrico a la posición mostrada en la figura.
"

# ╔═╡ c7e916c6-1579-11eb-1e5f-19a5ba0f547a
md"**Desarrollo**

Para obtener el trabajo, se necesita tener una expresión de $F$ en relación a $x$.
Es decir, no se remplaza $x$ por $L/2$.

```math
F_{\text{ext}}(x) = \dfrac{Q^2}{
\left(
    \dfrac{2 \pi \epsilon_0 ab}{b-a}\left(\dfrac{\kappa L + x(1-\kappa)}{L} \right)
\right)^2}
\left(
    \dfrac{2 \pi \epsilon_0 ab}{(b-a)L} (1-\kappa)
\right)
```

simplificando, queda:

```math
F_{\text{ext}}(x) = \dfrac
{Q^2(b-a)L (1 - \kappa)}
{2 \pi \epsilon_0 a b (\kappa L + x(1-\kappa))^2}
```

```math
F_{\text{ext}}(x) = \dfrac{Q^2(b-a)L (1 - \kappa)}{2 \pi \epsilon_0 a b}
\dfrac{1}{(\kappa L + x(1-\kappa))^2}
```

ahora, se integra por la distancia $dx$ desde $0$ hasta $L/2$

```math
W = \int_0^{L/2} F_{\text{ext}}(x) 
= \dfrac{Q^2(b-a)L (1 - \kappa)}{2 \pi \epsilon_0 a b}
\int_0^{L/2} \dfrac{1}{(\kappa L + x(1-\kappa))^2} dx
```

remplazando 

```math
u = \kappa L + x(1-\kappa)
```

```math
du = (1-\kappa) dx 
```

```math
W = \dfrac{Q^2(b-a)L (1 - \kappa)}{2 \pi \epsilon_0 a b}
\dfrac{1}{(1-\kappa)} \int_{\kappa L}^{\frac{L(\kappa+1)}{2}} \dfrac{1}{u^2} du
```

```math
W = \dfrac{Q^2(b-a)L }{2 \pi \epsilon_0 a b}
\left[ - \dfrac{1}{u} \right]_{\kappa L}^{\frac{L(\kappa+1)}{2}}
```

```math
W = \dfrac{Q^2(b-a)L }{2 \pi \epsilon_0 a b}
\left( \dfrac{1}{\kappa L} - \dfrac{2}{L(\kappa+1)} \right)
```

```math
W = \dfrac{Q^2(b-a)}{2 \pi \epsilon_0 a b}
\left( \dfrac{1}{\kappa} - \dfrac{2}{\kappa+1} \right)
```

```math
W = \dfrac{Q^2(b-a)}{2 \pi \epsilon_0 a b}
\left( \dfrac{\kappa + 1 - 2 \kappa}{\kappa (\kappa+1)} \right)
```

```math
W = \dfrac{Q^2(b-a)(1 - \kappa)}{2 \pi \epsilon_0 \kappa a b (\kappa+1)}
```
"

# ╔═╡ 7fd7c15c-1583-11eb-08d8-03630d9f0e93
(C^2 * m)/( (C^2 / (N * m^2)) * m^2 )  # Ver si las unidades calzan

# ╔═╡ 2db27262-14ce-11eb-325d-0f9659887927
md"## Pregunta 2
La región entre dos esferas conductoras concéntricas de
grosores despreciables y de radios $a$ y $b$ está llena
de un material conductor con resistividad $\rho$."

# ╔═╡ 5838b090-14d2-11eb-2659-ef58e5009128
md"
i) Demuestre que la resistencia entre las esferas está dada por:

$R = \dfrac{\rho}{4 \pi} \left(\dfrac{1}{a} - \dfrac{1}{b}\right)$
"

# ╔═╡ b4e71b30-1525-11eb-22ce-63ec1d30e1b7
md"**Desarrollo**

Se define la resistencia como

$$R \equiv \dfrac{l}{\sigma A} \equiv \dfrac{\Delta V}{I}$$

con

$$\rho \equiv \dfrac{1}{\sigma}$$

La distancia $r$ es toma valores en $a < r < b$,
y el área $A$ está dada por $4 \pi r^2$.
La resistividad es constante. Por lo tanto,
considerando un radio $dr$, se tiene que integrar:

```math
R = \int_a^b \dfrac{dr}{\sigma 4 \pi r^2}
  = \dfrac{\rho}{4\pi} \int_a^b \dfrac{1}{r^2}
  = \dfrac{\rho}{4\pi} \left[ -\dfrac{1}{r} \right]_a^b
  = \dfrac{\rho}{4\pi} \left( \dfrac{1}{a} - \dfrac{1}{b} \right)
```
"

# ╔═╡ 2b811c1a-155c-11eb-1abd-81896e0fe6f6
md"---"

# ╔═╡ acf92970-14d2-11eb-2c4f-adbe69d411c8
md"
ii) Deduzca una expresión para la densidad de corriente en función del
radio, en términos de la diferencia de potencial $V_{ab}$ entre las esferas.
"

# ╔═╡ cae59210-1528-11eb-0f41-11e97925cf6d
md"""**Desarrollo**

Se busca obtener $\vec{J}$.

Considerando que:

```math
J = \dfrac{I}{A}
```
```math
R \equiv \dfrac{l}{\sigma A} \equiv \dfrac{\Delta V}{I}
```

Remplazando se obtiene:

```math
J = \dfrac{I}{A}
= \dfrac{\Delta V}{A R}
= \Delta V \dfrac{\sigma}{l}
```

Cambiando las variables por los valores conocidos se obtiene:

```math
J = \dfrac{\Delta V_{ab}}{\rho r}
```
"""

# ╔═╡ 27bb8188-155c-11eb-3d13-751796c1c90a
md"---"

# ╔═╡ cc8de0f0-14d2-11eb-3cb2-8ff199c3ed71
md"
iii) Demuestre que el resultado del inciso i) se reduce a la ecuación
para la resistencia $R = \rho L/A$, donde $L$ es el largo del conductor
y $A$ su sección transversal, cuando la separación $L = b - a$ entre
las esferas es pequeña.
"

# ╔═╡ 25d025e0-152a-11eb-1753-73edf2e49c75
md"**Desarrollo**

Son el resultado obtenido en i), se obtiene:


```math
R = \dfrac{\rho}{4\pi} \left( \dfrac{1}{a} - \dfrac{1}{b} \right)
  = \dfrac{\rho}{4\pi} \left( \dfrac{b - a}{ab} \right)
```

Por enunciado se tiene que $a \approx b$ y $L = b -a$.
Considerando a $r = a = b$ cuando $b - a$ tiende a $0$, se obtiene:

```math
R = \dfrac{\rho}{4\pi} \left( \dfrac{b - a}{ab} \right)
  = \dfrac{\rho L}{4 \pi r^2} = \dfrac{\rho L}{A}
```
"

# ╔═╡ 3406c710-14ce-11eb-1a2b-012e37143ae2
md"## Pregunta 3
Considere un circuito cerrado formado por dos baterías de
fem de $2 V$ y $4 V$ y resistencias internas de $2 \Omega$
cada una, teniendo sus terminales negativos unidos por un
cable de resistencia $8 \Omega$ y sus terminales positivos
por un cable de resistencia $4 V$. Una tercera resistencia
externa de $16 \Omega$ conecta los puntos medios de estos
dos cables."

# ╔═╡ 18c17a40-14d3-11eb-0d6a-e9b3348a1908
md"
i) Dibuje un diagrama del circuito eléctrico que muestre
las resistencias (internas y externas) y las baterías.
"

# ╔═╡ d3b016aa-154f-11eb-0345-db115337858f
md"**Desarrollo**"

# ╔═╡ 2b219c04-154d-11eb-0000-f587068ceed6
open("circuito.svg") do f
    as_svg(read(f, String))
end

# ╔═╡ 22a29b46-155c-11eb-3c67-5d935117bbd0
md"---"

# ╔═╡ 270adb52-14d3-11eb-0a6b-9ddc66f391f0
md"
ii) Calcule la corriente que fluye en cada rama del circuito
e indique claramente en que sentido circula la respectiva corriente.
"

# ╔═╡ bdda9882-154f-11eb-3840-6700c95b5591
md"**Desarrollo**"

# ╔═╡ 8b9bb2ec-1550-11eb-1a17-a7c42b200011
md"
Se busca $I_1$, $I_2$ e $I_3$, que representan la corriente
que fluye en las ramas $AB$, $CD$ y $EF$ respectivamente.
**Se asume inicialmente que el flujo en el punto
$C$ entra de $D$ y sale en $A$ y $E$**.


Por la condición asumida, se tiene que cumplir que $I_2 = I_1 + I_3$

El flujo A → B → D → C → A

```math
V_A = V_A + 2V - I_1 2Ω - I_1 2Ω - I_2 16Ω -I_14Ω
```

```math
2V = I_1 8Ω + I_2 16Ω
```

```math
I_1 = \dfrac{1V - I_2 8Ω}{4Ω}
```

El flujo E → F → D → C → E

```math
V_E = V_E + 4V - I_3 2Ω - I_3 2Ω - I_2 16Ω -I_3 4 Ω
```

```math
4V = I_3 8Ω + I_2 16Ω
```

```math
I_3 = \dfrac{1V - I_2 4Ω}{2Ω}
```

Uniendo las tres primeras ecuaciones e obtiene que:

```math
I_2 = I_1 + I_3
    = \dfrac{1V - I_2 8Ω}{4Ω} + \dfrac{1V - I_2 4Ω}{2Ω}
```

```math
I_2 4Ω = 1V - I_2 8Ω + 2V - I_2 8Ω
```

```math
I_2 = \dfrac{3}{20} A
```

por lo tanto:

```math
I_1 = \dfrac{1V - \dfrac{12}{10} V}{4Ω} = \dfrac{-1}{20}
```
```math
I_3 = \dfrac{1V - \dfrac{12}{20} V}{2Ω} = \dfrac{1}{5}
```
"

# ╔═╡ 0ee6635a-155a-11eb-07de-515623c46cff
I₁ = (1V - 8 * 3V // 20) // 4Ω |> upreferred

# ╔═╡ 5eae2496-1559-11eb-1c40-67f34a48e585
I₂ = (1V - 4 * 3V//20) // 2Ω + (1V - 8 * 3V//20) // 4Ω |> upreferred

# ╔═╡ fe4d6c6c-1559-11eb-2bef-d39a931706d6
I₃ = (1V - 4 * 3V//20) // 2Ω |> upreferred

# ╔═╡ d3dca6a6-155a-11eb-074e-a1b5d85d66f5
md"Para confirmar los cálculos, se considera otro flujo: 
A → B → D → F → E → C → A

```math
V_A = V_A + 2V - I_1 2Ω - I_1 2Ω + I_3 2Ω + I_3 2Ω - 4V + I_3 4Ω - I_1 4Ω
```
"

# ╔═╡ 4f2ac066-155b-11eb-1928-f30c3dd47c64
2V - I₁ * 2Ω - I₁ * 2Ω + I₃ * 2Ω + I₃ * 2Ω - 4V + I₃ * 4Ω - I₁ * 4Ω == 0V

# ╔═╡ 7cc5a222-155b-11eb-14a9-6bfe31d2cb5d
md"Como nuevamente el cambio de potencial $V$ es igual a 0, son correctos"

# ╔═╡ a86375a4-155a-11eb-07f4-add10194bad7
md"El flujo que se asumió en el comienzo fue erróneo,
por lo que $I_1$ dio negativo.
**La dirección de $I_1$ es contraria a la asumida**,
el flujo está entrando a $C$ desde $A$ y no saliendo.
"

# ╔═╡ 18621d64-155c-11eb-27b3-49adade01a5d
md"---"

# ╔═╡ 36cc3660-14d3-11eb-0aff-655d72533918
md"
iii) Calcule la diferencia de potencial entre los extremos de
la resistencia externa de $16 \Omega$ y la potencia disipada en ella.
"

# ╔═╡ eb2c7c30-155c-11eb-0c07-198f81436d02
md"**Desarrollo**

Se pide calcular, para el diagrama, la diferencia de potencial $\Delta V_{CD}$
Esta esta dada por:

```math
\Delta V_{CD}
= I_2 16 \Omega
= \dfrac{3 × 16}{20} V
= \dfrac{12}{5} V
```
"

# ╔═╡ 2c8b0ea6-155f-11eb-3990-95053c55339d
V_cd =  uconvert(V, I₂ * 16Ω)

# ╔═╡ fef0395e-155d-11eb-31e4-4b4aa457d6de
md"La potencia disparada por un resistor es

```math
\mathcal{P} = I \Delta V
```

remplazando, se obtiene:

```math
\mathcal{P} = I_2 \Delta V_{CD}
            = \dfrac{3 × 12}{20 × 5} W
            = \dfrac{9}{25} W
```
"

# ╔═╡ 51bda7a6-155f-11eb-11b0-617618b904bd
uconvert(W, V_cd * I₂)

# ╔═╡ Cell order:
# ╠═fd8a65a2-14d4-11eb-1d08-1f273b61eba3
# ╟─79069da0-14cd-11eb-08c9-9bcea31f0245
# ╠═380d972e-1561-11eb-07c5-513d7e9e9683
# ╟─45ef08fa-1561-11eb-0f3f-1154cd3a3c77
# ╟─5e773de0-14d3-11eb-2c14-cb1f543690f9
# ╟─82533da2-1561-11eb-2284-31a60116fb72
# ╠═b5b527ae-1585-11eb-080f-bf467998763d
# ╟─313ed70a-155c-11eb-0fec-39cb8d57ba2a
# ╟─6cad6510-14d3-11eb-1409-372992f4e59a
# ╟─c7e916c6-1579-11eb-1e5f-19a5ba0f547a
# ╠═7fd7c15c-1583-11eb-08d8-03630d9f0e93
# ╟─2db27262-14ce-11eb-325d-0f9659887927
# ╟─5838b090-14d2-11eb-2659-ef58e5009128
# ╟─b4e71b30-1525-11eb-22ce-63ec1d30e1b7
# ╟─2b811c1a-155c-11eb-1abd-81896e0fe6f6
# ╟─acf92970-14d2-11eb-2c4f-adbe69d411c8
# ╟─cae59210-1528-11eb-0f41-11e97925cf6d
# ╟─27bb8188-155c-11eb-3d13-751796c1c90a
# ╟─cc8de0f0-14d2-11eb-3cb2-8ff199c3ed71
# ╟─25d025e0-152a-11eb-1753-73edf2e49c75
# ╟─3406c710-14ce-11eb-1a2b-012e37143ae2
# ╟─18c17a40-14d3-11eb-0d6a-e9b3348a1908
# ╟─d3b016aa-154f-11eb-0345-db115337858f
# ╟─2b219c04-154d-11eb-0000-f587068ceed6
# ╟─22a29b46-155c-11eb-3c67-5d935117bbd0
# ╟─270adb52-14d3-11eb-0a6b-9ddc66f391f0
# ╟─bdda9882-154f-11eb-3840-6700c95b5591
# ╟─8b9bb2ec-1550-11eb-1a17-a7c42b200011
# ╠═0ee6635a-155a-11eb-07de-515623c46cff
# ╠═5eae2496-1559-11eb-1c40-67f34a48e585
# ╠═fe4d6c6c-1559-11eb-2bef-d39a931706d6
# ╟─d3dca6a6-155a-11eb-074e-a1b5d85d66f5
# ╠═4f2ac066-155b-11eb-1928-f30c3dd47c64
# ╟─7cc5a222-155b-11eb-14a9-6bfe31d2cb5d
# ╟─a86375a4-155a-11eb-07f4-add10194bad7
# ╟─18621d64-155c-11eb-27b3-49adade01a5d
# ╟─36cc3660-14d3-11eb-0aff-655d72533918
# ╟─eb2c7c30-155c-11eb-0c07-198f81436d02
# ╠═2c8b0ea6-155f-11eb-3990-95053c55339d
# ╟─fef0395e-155d-11eb-31e4-4b4aa457d6de
# ╠═51bda7a6-155f-11eb-11b0-617618b904bd
