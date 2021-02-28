### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 0417dc5e-49f5-11eb-2632-bb3e653107b3
begin
	using LinearAlgebra
	using Plots
	# Para hacer el código más bonito
	∑ = sum
	×(x::Number, y::Number) = x * y
	×(x::Number, y::Array) = x * y
	# Funciones de utilidad
	invert(A::Array) = [ map(a -> a[i], A) for i=1:size(A[1])[1] ]
end;

# ╔═╡ 1af127cc-4a41-11eb-1283-1fbf23fca396
md"# IMT1001-T03: Cuerpos"

# ╔═╡ 1a060954-49ec-11eb-271c-6f1ddb8859c9
md"""
> El hamiltoniano es una función escalar a partir de la cual pueden obtenerse
> las ecuaciones de movimiento de un sistema mecánico clásico que se emplea en el
> enfoque hamiltoniano de la mecánica clásica.
>
> Bajo ciertas condiciones relacionadas con las características del sistema
> (sistema conservativo) y las coordenadas empleadas, el hamiltoniano puede
> identificarse con la energía mecánica del sistema, aunque esto no sucede para
> todos los sistemas.
>
> Usualmente el hamiltoniano es una función de las variables de posición y sus
> momentos conjugados, o más generalmente puede definirse como una función escalar
> definida sobre el espacio fásico del sistema.
>
> [Wikipedia: Hamiltoniano (mecánica clásica)]
> (https://es.wikipedia.org/wiki/Hamiltoniano_(mec%C3%A1nica_cl%C3%A1sica))
"""

# ╔═╡ 549f323c-4a4d-11eb-189f-8189356c3bc5
md"## Definición de funciones"

# ╔═╡ 35f5a048-4a37-11eb-15f7-97a53d2bdeaa
md"""
Para un problema de ``n`` cuerpos, se puede expresar el hamiltoniano como:

```math
\mathcal{H}(r, p) =
\sum_{i=1}^n \dfrac{{p_i}^2}{2m_i}
- \sum_{i=1}^n \sum_{j = 1,\ j \neq i}^n \dfrac{G m_i m_j}{||r_i - r_j||}
```

donde ``r`` es el vector posición, ``p`` el momentum, ``m`` la masa de los cuerpos 
y ``G`` la constante de gravitación.
"""

# ╔═╡ 2cfeda9a-4a37-11eb-1e98-b109c106eb1c
md"""
Las deribadas parciales de ``\mathcal{H}`` son:

```math
\dfrac{\partial\mathcal{H}}{\partial r_i}
= G M_i \sum_{j = 1,\ j \neq i}^n \dfrac{(r_i - r_j) M_j}{(||r_i - r_j||)^3}
```

```math
\dfrac{\partial\mathcal{H}}{\partial p_i} = \dfrac{p_i}{M_i}
```
"""

# ╔═╡ 5eb38216-49f6-11eb-2009-3f4e07dd99fd
function Hₚ(R, P, M)
	[P[i]/M[i] for i=1:size(M,1)]
end;

# ╔═╡ 8a78496c-4a38-11eb-3811-ef20c2be8cf8
md"""
Para resolver numericamente este sistema de ecuaciones diferenciales, se utiliza
el método de Stormer Vertel Hamiltoniano
"""

# ╔═╡ 5f3ee994-4a4d-11eb-239c-b74f49800666
md"### Funciones adicionales"

# ╔═╡ 78c9cc9a-4a38-11eb-219f-6f8e021a4a10
md"""
Para una mayor facilidad al crear los objetos, se utiliza un struct:
"""

# ╔═╡ fcd511f4-49f0-11eb-0a1a-efd74017c0f5
mutable struct Body
	r::Array{Float64}
	p::Array{Float64}
	m::Float64
end

# ╔═╡ 78b63c38-4a39-11eb-1ffc-79b3d36522c7
md"""
Y una función que tranforme esos objetos a los vectores del hamiltoniano para luego
entregarlos al método numérico
"""

# ╔═╡ 95c5d6f0-4a41-11eb-2215-a36f47ae2143
md"## Variables del sistema"

# ╔═╡ 803f613e-4a41-11eb-3389-395a3d87671e
gravitational_constant = 2π; # Para evitar númeos grandes

# ╔═╡ c49e1f8e-49f1-11eb-0d04-632e98495b84
function H(R, P, M; G=gravitational_constant)
	n = size(M, 1)
	(
		∑(norm(P[i])^2 / 2M[i] for i=1:n)
		- ∑(G*M[i]*M[j] / norm(R[i] - R[j]) for i=1:n, j=1:n if i≠j)
	)
end;

# ╔═╡ 40ca131e-49f6-11eb-0d38-8bac2b02771b
function Hᵣ(R, P, M; G=gravitational_constant)
	n = size(M, 1)
	[
		( G*M[i]*∑((R[i] - R[j])*M[j]/norm(R[i] - R[j])^3 for j=1:n if i ≠ j))
		for i=1:n
	]
end;

# ╔═╡ 3016192e-4a2a-11eb-2b17-2f61859eacdd
function störmer_verlet(R, P, M, h, steps, save_prop)
	# Arrays para guardar los valores
	R_values = [R]
	P_values = [P]
	# Crea un solo array de cerros
	zero_arr = zeros(size(R)) 
	# Almacena los últimos valores
	R_last = R
	P_last = P
	push_when = round(Int, 1//save_prop)
	for n ∈ 1:steps	
		# Método numérico
		# P½ = P_last - h/2 × Hᵣ(R_last, zero_arr, M)
		# R_last += h × Hₚ(zero_arr, P½, M)
		# P_last = P½ - h/2 × Hᵣ(R_last, P½, M)
		# Alternativo
		R½ = R_last - h/2 × Hₚ(zero_arr, P_last, M)
		P_last += h × Hᵣ(R½, zero_arr, M)
		R_last = R½ - h/2 × Hₚ(R½, P_last, M)
		# Guarda los valores
		if n % push_when == 0
			push!(R_values, R_last)
			push!(P_values, P_last)
		end
	end
	R_values, P_values
end;

# ╔═╡ 2cc314b2-4a2b-11eb-095d-55a5a40a4638
function simulate(bodies, h=0.01, steps=500, save_prop=1//10)
	R = getfield.(bodies, :r)
	P = getfield.(bodies, :p)
	M = getfield.(bodies, :m)
	störmer_verlet(R, P, M, h, steps, save_prop)
end;

# ╔═╡ 836421e2-4a41-11eb-0ee9-3b5984f4c5f7
DIMS = 3; # Dimenciones (para el plor solo sirven 2 y 3)

# ╔═╡ e053a6d6-4a41-11eb-1b5a-6db26d9bd80f
N_BODIES = 15; # Número de cuerpos

# ╔═╡ 84cf9714-4a41-11eb-32a9-6fa3695ef2c2
BODIES = Body[
	Body(20 × randn(Float64, (DIMS)), 4 × randn(Float64, (DIMS)), 3) for i=1:N_BODIES
];

# ╔═╡ 3f316212-4a4d-11eb-172c-c5bf247b4833
md"## Visualización"

# ╔═╡ ebe7d7ae-4a46-11eb-043f-451ffb49d1f9
# theme(:juno, labels=false, framestyle=:grid, c="#1DA1F2", bg="#15202B", msw=0)

# ╔═╡ 210e97be-4a4d-11eb-3802-b71fae1a92e8
l = [-30, 30]; # Rango del plot

# ╔═╡ c74c59ac-4a48-11eb-038f-97d182f9d947
scatter(invert(getfield.(BODIES, :r))..., xlim=l, ylim=l, zlim=l)

# ╔═╡ 9c4b9c62-4a41-11eb-1665-63f90674e1b3
md"Simulación"

# ╔═╡ ddff80e4-4a0f-11eb-1f70-f7ff566d983e
if true # Simular datos
	(R, P) = simulate(BODIES, 0.0005, 100_000, 1//1_000); 
end;

# ╔═╡ be8f4cc0-4a2c-11eb-0940-e5e79d7da591
if true # Cambiar esto para no ejecutarno en cada cambio
	q = round(Int, length(R) / 200) # 200 frames
	@gif for r ∈ R
		scatter(invert(r)..., xlim=l, ylim=l, zlim=l)
	end
end

# ╔═╡ Cell order:
# ╟─1af127cc-4a41-11eb-1283-1fbf23fca396
# ╟─1a060954-49ec-11eb-271c-6f1ddb8859c9
# ╟─0417dc5e-49f5-11eb-2632-bb3e653107b3
# ╟─549f323c-4a4d-11eb-189f-8189356c3bc5
# ╟─35f5a048-4a37-11eb-15f7-97a53d2bdeaa
# ╠═c49e1f8e-49f1-11eb-0d04-632e98495b84
# ╟─2cfeda9a-4a37-11eb-1e98-b109c106eb1c
# ╠═40ca131e-49f6-11eb-0d38-8bac2b02771b
# ╠═5eb38216-49f6-11eb-2009-3f4e07dd99fd
# ╟─8a78496c-4a38-11eb-3811-ef20c2be8cf8
# ╠═3016192e-4a2a-11eb-2b17-2f61859eacdd
# ╟─5f3ee994-4a4d-11eb-239c-b74f49800666
# ╟─78c9cc9a-4a38-11eb-219f-6f8e021a4a10
# ╠═fcd511f4-49f0-11eb-0a1a-efd74017c0f5
# ╟─78b63c38-4a39-11eb-1ffc-79b3d36522c7
# ╠═2cc314b2-4a2b-11eb-095d-55a5a40a4638
# ╟─95c5d6f0-4a41-11eb-2215-a36f47ae2143
# ╠═803f613e-4a41-11eb-3389-395a3d87671e
# ╠═836421e2-4a41-11eb-0ee9-3b5984f4c5f7
# ╠═e053a6d6-4a41-11eb-1b5a-6db26d9bd80f
# ╠═84cf9714-4a41-11eb-32a9-6fa3695ef2c2
# ╟─3f316212-4a4d-11eb-172c-c5bf247b4833
# ╠═ebe7d7ae-4a46-11eb-043f-451ffb49d1f9
# ╠═210e97be-4a4d-11eb-3802-b71fae1a92e8
# ╠═c74c59ac-4a48-11eb-038f-97d182f9d947
# ╟─9c4b9c62-4a41-11eb-1665-63f90674e1b3
# ╠═ddff80e4-4a0f-11eb-1f70-f7ff566d983e
# ╠═be8f4cc0-4a2c-11eb-0940-e5e79d7da591
