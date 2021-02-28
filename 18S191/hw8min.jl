### A Pluto.jl notebook ###
# v0.12.18

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

# ╔═╡ 6304e512-51b7-11eb-16f3-39f09e95edfb
begin 
	using PlutoUI
	using LinearAlgebra
	using Images
end

# ╔═╡ c56846ba-51ec-11eb-2932-83c0d8b67612
md"""
# RayTrasing

@benjavicente

This code uses code and math from:
- [MIT 18.S191 Homework 8](https://computationalthinking.mit.edu/Fall20/hw8/)
- [Inigo Quilez](https://www.iquilezles.org/) 
"""

# ╔═╡ c4671dd2-51b7-11eb-2f57-5d3464ae484c
md"## Objects & definitions"

# ╔═╡ ddfd6528-51b7-11eb-1794-c595ee97b945
abstract type SceneObject end

# ╔═╡ 8b339530-51b8-11eb-3f61-ff1a82e75f36
md"""### Rays

Rays objects to be traced
"""

# ╔═╡ e016ab52-521e-11eb-3eff-9b659626eeee
abstract type AbstracrRay end 

# ╔═╡ a8db238a-51b7-11eb-2cb3-f98eb742f9c8
struct Ray <: AbstracrRay
	"Position vector"
	o::Vector{Float64}
	"Direction vector"
	d::Vector{Float64}
	"Color associated with the photon"
	c::RGB{N0f8}
	"Current index of refraction"
	ior::Float64
	# Constructors
	function Ray(p, l, c::RGB, ior::Float64)
		if max(c.r, c.b, c.g) > 1
			error("invalid color")
		else
			new(p, normalize(l), c, ior)
		end
	end
	Ray(p, l, c::RGB) = new(p, normalize(l), c, 1.0)
	Ray(p, l) = new(p, normalize(l), zero(RGB), 1.0)
end

# ╔═╡ baee8c12-5214-11eb-0029-a3acef018c58
struct SplittedRay <: AbstractVector{Tuple{AbstracrRay, Float64}}

	# Used when an arrays splits (refraction & reflection & color)
	#TODO: beter type definition
	
	rays::Vector{AbstracrRay}
	weights::Vector{Float64}
	
	function SplittedRay(ray_weight...)
		rays    = collect(map(e -> e[1], ray_weight))
		weights = collect(map(e -> e[2], ray_weight))
		weights = weights ./ sum(weights)
		new(rays, weights)
	end
	
	Base.size(A::SplittedRay) = size(A.rays)
	Base.getindex(A::SplittedRay, i) = (ray = A.rays[i], weight = A.weights[i])
end

# ╔═╡ 1251c552-521d-11eb-2213-df4840eb7e7b
struct RaySource <: AbstracrRay
	# Used when a ray reached a light source, so the ray stops
	c::RGB{N0f8}
end

# ╔═╡ 73fdede2-51bb-11eb-2d41-cbcbdf68d68c
md"""### Camara

Camara that suports diferent positions and rotation
"""

# ╔═╡ 80cdf97c-51bb-11eb-3aac-c3ab13bddb5d
struct Camara
	"Resolution"
	res::Tuple{Int, Int}
	"Position"
	p::Vector{Float64}
	"Direction"
	l::Vector{Float64}
	"Rotation"
	r::Float64 
	"Size"
	size::Tuple{Float64, Float64}
	"Distance from the screen"
	focal_length::Float64
end

# ╔═╡ 0c7e3e8a-51be-11eb-3667-c7fd3dbccfd8
function init_rays(cam::Camara)
	#TODO: Ver caso donde cam.l × rot = Vect(0)
	#TODO: Ver structs con vectores normalizados
	
	# Vectores del plano de la cámara
	rot = - [sin(cam.r), cos(cam.r), 0]  
	vx = normalize(cam.l × rot)
	vy = normalize(cam.l × vx)

	# Tamaño de los pixeles
	pw = cam.size[1] / cam.res[1]
	ph = cam.size[2] / cam.res[2]
	
	# Contendor de los rayos
	rays = Array{Ray}(undef, cam.res[2], cam.res[1])
	
	# Posiciones de los pixeles
	col_h, row_h = (cam.res .+ 1)./2
	for row=1:cam.res[2], col=1:cam.res[1]
		pix_pos = vx*pw*(col - col_h) + vy*ph*(row_h - row)
		#TODO: position works only when it is 0
		#TODO: if it isn't, if will afect the rotation and focal lenght

		ray_dir = pix_pos + (normalize(cam.l) * cam.focal_length * maximum(cam.size))
		rays[row, col] = Ray(pix_pos + cam.p, normalize(ray_dir))
	end

	rays
end;

# ╔═╡ 6d3360c6-51bd-11eb-21fc-dfc2f9dadf34
md"### Reflect and refract"

# ╔═╡ 76822162-51bd-11eb-1b85-69b19e545cf3
reflect(ℓ₁::Vector, n̂::Vector) = normalize(ℓ₁ - 2 * dot(ℓ₁, n̂) * n̂);

# ╔═╡ 88eef78a-51bd-11eb-1cd1-679f51940bc5
function refract(ℓ₁::Vector, n̂::Vector, old_ior, new_ior)
	r = old_ior / new_ior
	n̂_oriented = dot(ℓ₁, n̂) > 0 ? -n̂ : n̂
	c = -dot(ℓ₁, n̂_oriented)
	if abs(c) > 0.999
		ℓ₁
	else
		f = 1 - r^2 * (1 - c^2)
		if f < 0
			ℓ₁
		else
			normalize(r * ℓ₁ + (r*c - √f) * n̂_oriented)
		end
	end
end;

# ╔═╡ 39392c38-51b8-11eb-1da7-2b6638135adc
md"### Intersection and misses"

# ╔═╡ 094d1a04-51b8-11eb-3f63-2bda58300a7e
struct Miss end

# ╔═╡ 1553bf7c-51b8-11eb-29ce-51462fc49142
struct Intersection{object<:SceneObject}
	object::object
	distance::Float64
	point::Vector{Float64}
end

# ╔═╡ 37a2afb6-51b8-11eb-06bc-db2022524f7e
begin
	Base.isless(a::Miss, b::Miss) = false
	Base.isless(a::Miss, b::Intersection) = false
	Base.isless(a::Intersection, b::Miss) = true
	Base.isless(a::Intersection, b::Intersection) = a.distance < b.distance
end

# ╔═╡ 9b4ca878-51b8-11eb-08dc-6f6e3aed636f
md"### Scene objects"

# ╔═╡ f10b0e66-51eb-11eb-190b-2f7f45040be0
md"""
Scene objects **must have** a `intersection` and `interact` function, that returns a
`Intersection` or a `Miss`, and a `Ray` or a `SplittedRay` respectively. 

A Surface struct is provided to help with the object's material properties.
"""

# ╔═╡ 6bcf6a62-51b9-11eb-0fbd-6f5d321dbbb7
md"#### Surface"

# ╔═╡ 581a480c-5222-11eb-3781-a50c3a34864d
md"**TODO use Surface to create SplittedRays**"

# ╔═╡ 72b7015a-51b9-11eb-3da0-dba937549c44
struct Surface
	"Reflectivity"
	r::Float64
	"Transmission"
	t::Float64
	"Color"
	c::RGB{N0f8}
	"Index of refraction"
	ior::Float64
end

# ╔═╡ e8ad9c22-51e4-11eb-1b6b-fd8a1c5f4527
md"#### Sky-Box"

# ╔═╡ f07e0ac2-51e4-11eb-0ea6-237a247c5e0f
struct SkyBox <: SceneObject
	c::Function
	# Base color
	SkyBox() = new(dir -> RGB( (dir ./ 2maximum(abs.(dir)) .+ 0.5 ) ... ));
end

# ╔═╡ e8960a46-51e5-11eb-1b8f-d95229f8b906
intersection(ray::Ray, skybox::SkyBox)= Intersection(skybox, Inf, ray.d * Inf);

# ╔═╡ 749497ac-51e7-11eb-143a-6dad80e8f9f8
interact(ray::Ray, hit::Intersection{SkyBox}, n) = RaySource(hit.object.c(ray.d));

# ╔═╡ 4a19fca2-51b9-11eb-09ed-55ee5e69be3c
md"#### Sphere"

# ╔═╡ 54425724-51b9-11eb-3b7f-717740da73fc
struct Sphere <: SceneObject
	"Position"
	p::Vector{Float64}
	"Radius"
	r::Float64
	"Surface properties"
	s::Surface
end

# ╔═╡ 9809780c-51b9-11eb-3975-c18463dbf1ec
function intersection(ray::Ray, sphere::Sphere; ϵ=1e-3)
	a = ray.d ⋅ ray.d
	b = 2.0*(ray.d ⋅ (ray.o - sphere.p))
	c = (ray.o - sphere.p) ⋅ (ray.o - sphere.p) - sphere.r^2
	d = b^2 - 4*a*c
	if d <= 0
		Miss()
	else
		t1 = (-b - √d)/2a
		if t1 > ϵ
			return Intersection(sphere, t1, ray.o + t1 * ray.d)
		end
		t2 = (-b + √d)/2a
		if t2 > ϵ
			return Intersection(sphere, t2, ray.o + t2 * ray.d)
		end
		Miss()
	end
end;

# ╔═╡ 48625252-51bd-11eb-327d-332ae52bf5e3
normal(p::Vector{Float64}, s::Sphere) = normalize(p - s.p);

# ╔═╡ d3e41376-51e8-11eb-0e3d-6fbb1739d034
function interact(ray::Ray, hit::Intersection{Sphere}, n::Int)
	# Ray(hit.point, ray.d, hit.object.s.c, ray.ior)
	
	SplittedRay(
		(RaySource(hit.object.s.c), 0.8),
		(
			Ray(
				hit.point,
				reflect(ray.d, normal(hit.point, hit.object)),
				hit.object.s.c,
				ray.ior),
			0.2
		)
	)
end;

# ╔═╡ 848c1b6a-51ee-11eb-317f-1d7e4c443b98
md"#### Plane"

# ╔═╡ 8d275ca8-51ee-11eb-06e1-6bc751c15f7b
struct Plane <: SceneObject
	"Normal"
	norm::Vector{Float64}
	"Position"
	p::Vector{Float64}
	"Surface properties"
	s::Surface
end

# ╔═╡ d999e786-51ee-11eb-134f-3792f1f98df0
function intersection(ray::Ray, plane::Plane; ϵ=1e-3)
	t = ((plane.p - ray.o) ⋅ plane.norm) / (ray.d ⋅ plane.norm)
	if t > ϵ
		Intersection(plane, t, ray.o + t * ray.d)
	else
		Miss()
	end
end;

# ╔═╡ 54e3b5de-51b8-11eb-0030-617b1cc35903
function closest_hit(photon::Ray, objects::Vector{<:SceneObject})
	minimum(intersection.([photon], objects))
end;

# ╔═╡ 353bf98a-51ef-11eb-3f78-47fd4373a62f
function interact(ray::Ray, hit::Intersection{Plane}, n::Int)
	SplittedRay(
		(RaySource(hit.object.s.c), 0.5),
		(Ray(hit.point, reflect(ray.d, hit.object.norm),hit.object.s.c,ray.ior), 0.5)
	)
end;

# ╔═╡ 86e32ef4-51e3-11eb-1000-fd4b2c287321
md"## Simultaion"

# ╔═╡ cadd4cd6-51e6-11eb-2a22-c1a667903860
function ray_step(ray::Ray, objs::Vector{O}, n::Int) where {O <: SceneObject}
	n == 0 && return ray.c

	hit = closest_hit(ray, objs)
	interact_result = interact(ray, hit, n)

	if typeof(interact_result) <: Ray
		ray_step(interact_result, objs, n - 1)
	elseif typeof(interact_result) <: RaySource
		interact_result.c
	elseif typeof(interact_result) <: SplittedRay
		col = zero(RGB{N0f8})
		for r in interact_result
			if typeof(r.ray) <: RaySource
				col += r.ray.c * r.weight
			else
				col += ray_step(r.ray, objs, n - 1) * r.weight
			end
		end
		col
	else
		error("interact returned $(typeof(ray_data)) instead of RayType")
	end

end;

# ╔═╡ b67d8fd8-51e3-11eb-0fbd-756e8be573ec
function ray_trace(objs::Vector{O}, cam::Camara; n=10) where {O <: SceneObject}
	rays = init_rays(cam)
	result = ray_step.(rays, [objs], [n])
end;

# ╔═╡ 0f2e145e-51e9-11eb-3e51-89ca54c5f210
extract_colors(rays) = map(ray -> ray.c, rays)

# ╔═╡ 1bfb8e8e-526e-11eb-0ada-4feaff136226
md"""
Rotate the cámara clockwise $(@bind rot Slider(-2π:π/16:2π, default=0; show_value=true))

Rotate camara left&right $(@bind θ Slider(-2π:π/32:2π, default=0, show_value=true))

Rotate camara up&down $(@bind α Slider(-π/2:π/32:π/2, default=0, show_value=true))

Phocal lenght $(@bind ph Slider(0.05:0.05:2, show_value=true, default=0.5))

Position X $(@bind x Slider(-100:100, default=0, show_value=true))
         Y $(@bind y Slider(-100:100, default=0, show_value=true))
         Z $(@bind z Slider(-100:100, default=0, show_value=true))

Size i $(@bind size_i Slider(0:50, default=16, show_value=true))
     j $(@bind size_j Slider(0:50, default=9, show_value=true))

Resolution resolution $(@bind resolution Slider(1:50, default=8, show_value=true))
"""

# ╔═╡ f883f6c2-52aa-11eb-18cc-81315890d01a
let
	if true
		scene = [
			SkyBox(),
			Sphere([0,2,50], 5, Surface(0,0,RGB(0.2, 0.5, 0.6), 1)),
			Sphere([20,0,50], 5, Surface(0,0,RGB(0.8, 0.5, 0.6), 1)),
			Sphere([0,-30,60], 5, Surface(0,0,RGB(0.8, 0.8, 0.7), 1)),
			Sphere([0,10,20], 5, Surface(0,0,RGB(0.6, 0.2, 0.7), 1)),
			Sphere([30,-20,50], 5, Surface(0,0,RGB(0.9, 0.9, 0.3), 1)),
			Sphere([-29,22,60], 10, Surface(0,0,RGB(0.9, 0.9, 0.3), 1)),
			Plane([0,1,0], [0,-30,0], Surface(0,0,RGB(0.9,0.9,0.9), 1)),
		]


		camara = Camara(
			(size_i, size_j).*resolution,
			[x,y,z],
			[sin(θ),sin(α),cos(θ)],
			rot,
			(size_i, size_j),
			ph
		)

		result = ray_trace(scene, camara, n=2)
	end
end

# ╔═╡ fe26e9c6-51ff-11eb-0fc4-418824ff1e15
md"## Other stuff"

# ╔═╡ 04dd1cda-52b0-11eb-1b3c-c755f4479093
md"Do animation? $(@bind do_animation CheckBox())"

# ╔═╡ e1a97074-51e7-11eb-2450-95bc85909f6a
if do_animation
	resolution_temp = 50
	rev = 64
	framestack = Vector{Array{RGB, 2}}(undef, 64)
	let
		resolution = resolution_temp
		frac = 2π/rev
		α = -π/16

		Base.Threads.@threads for i=1:rev
			scene = [
				SkyBox(),
				Sphere([0,2,50], 9, Surface(0,0,RGB(0.2, 0.5, 0.6), 1)),
				Sphere([20,-5,50], 8, Surface(0,0,RGB(0.8, 0.5, 0.6), 1)),
				Sphere([0,-30,60], 3, Surface(0,0,RGB(0.8, 0.8, 0.7), 1)),
				Sphere([0,10,20], 5, Surface(0,0,RGB(0.6, 0.2, 0.7), 1)),
				Sphere([-10,-25,20], 12, Surface(0,0,RGB(0.9, 0.9, 0.9), 1)),
				Sphere([-10,0,30], 8, Surface(0,0,RGB(0.6, 0.4, 0.7), 1)),
				Sphere([30,-20,50], 9, Surface(0,0,RGB(0.9, 0.9, 0.3), 1)),
				Sphere([-29,22,60], 10, Surface(0,0,RGB(0.9, 0.9, 0.3), 1)),
				Plane([0,1,0], [0,-30,0], Surface(0,0,RGB(0.9,0.9,0.9), 1)),
			]

			camara = Camara(
				(size_i, size_j).*resolution,
				[sin(i*frac)*60,0,cos(i*frac)*60+40],
				[-sin(i*frac),sin(α),-cos(i*frac)],
				rot,
				(size_i, size_j),
				ph
			)

			framestack[i] = ray_trace(scene, camara, n=4)
		end
	end
end

# ╔═╡ e1287262-52af-11eb-38f0-bd2b81d20b07
if do_animation
	@bind t Slider(1:length(framestack))
end

# ╔═╡ 3dc903ae-52ad-11eb-05d3-e170d123bf2c
if do_animation
	framestack[t]
end

# ╔═╡ 9b6baae0-52b0-11eb-0107-7b2fd25a90d8
md"Save animation? $(@bind save_animation CheckBox())"

# ╔═╡ ebc85048-52af-11eb-11ce-433503934c45
if do_animation && save_animation
	using VideoIO
	props = [:priv_data => ("crf"=>"0","preset"=>"ultrafast")]
	encodevideo(
		"animation.mp4",
		convert(Vector{Array{RGB{N0f8}, 2}},framestack),
		framerate=8,
		AVCodecContextProperties=props
	)
	# using FileIO
	# save("animation.gif", cat(framestack...; dims=3); fps=5)
end

# ╔═╡ 25e00ed6-520f-11eb-160a-7d4e29a923d3
# Bigger and centered images
html"""
<style>
pluto-output.rich_output[mime*="image"] div {
	display: flex;
	justify-content: center;
}
pluto-output.rich_output[mime*="image"] img {
	width: 480px;
}
</style>
"""

# ╔═╡ 86bc1082-51ff-11eb-1682-2da0aad901a6
# old anomation
if false
	result_data = zeros(RGB, (225, 400, 119))

	let
		scene = [
			SkyBox(),
			Sphere([0,0,50], 5, Surface(0,0,RGB(0.2, 0.5, 0.6), 1)),
			Sphere([20,0,50], 5, Surface(0,0,RGB(0.8, 0.5, 0.6), 1)),
			Sphere([0,-40,60], 5, Surface(0,0,RGB(0.8, 0.8, 0.7), 1)),
			Sphere([0,10,20], 5, Surface(0,0,RGB(0.6, 0.2, 0.7), 1)),
			Sphere([30,10,50], 5, Surface(0,0,RGB(0.9, 0.9, 0.3), 1)),
			Plane([0,10,0], [0,-30,0], Surface(0,0,RGB(0.9,0.9,0.9), 1)),
		]
		θ = 0
		α = 0
		ph = 5
		i = 1
		function do_it(θ, α, ph, i)
			camara = Camara((400,225), [0,0,0], [sin(θ),sin(α),cos(θ)], 0, (10,8), ph)
			result = ray_trace(scene, camara)
			result_col = extract_colors(result)
			result_data[:,:,i] = result_col
		end
		for ph in 5:20           do_it(θ, α, ph, i); i += 1 end
		for ph in 20:-1:1        do_it(θ, α, ph, i); i += 1 end
		for ph in 1:5            do_it(θ, α, ph, i); i += 1 end
		for α  in 0:π/21:π/3     do_it(θ, α, ph, i); i += 1 end
		for α  in π/3:-π/21:-π/3 do_it(θ, α, ph, i); i += 1 end
		for α  in -π/3:π/21:π/6  do_it(θ, α, ph, i); i += 1 end
		for α  in π/6:-π/21:0    do_it(θ, α, ph, i); i += 1 end
		for θ  in 0:π/21:π/3     do_it(θ, α, ph, i); i += 1 end
		for θ  in π/3:-π/21:-π/3 do_it(θ, α, ph, i); i += 1 end
		for θ  in -π/3:π/21:π/3  do_it(θ, α, ph, i); i += 1 end
		for θ  in π/3:-π/21:0    do_it(θ, α, ph, i); i += 1 end
		result_data
	end
	# save("rt.gif", result_data)
end

# ╔═╡ Cell order:
# ╟─c56846ba-51ec-11eb-2932-83c0d8b67612
# ╠═6304e512-51b7-11eb-16f3-39f09e95edfb
# ╟─c4671dd2-51b7-11eb-2f57-5d3464ae484c
# ╠═ddfd6528-51b7-11eb-1794-c595ee97b945
# ╟─8b339530-51b8-11eb-3f61-ff1a82e75f36
# ╠═e016ab52-521e-11eb-3eff-9b659626eeee
# ╠═a8db238a-51b7-11eb-2cb3-f98eb742f9c8
# ╠═baee8c12-5214-11eb-0029-a3acef018c58
# ╠═1251c552-521d-11eb-2213-df4840eb7e7b
# ╟─73fdede2-51bb-11eb-2d41-cbcbdf68d68c
# ╠═80cdf97c-51bb-11eb-3aac-c3ab13bddb5d
# ╠═0c7e3e8a-51be-11eb-3667-c7fd3dbccfd8
# ╟─6d3360c6-51bd-11eb-21fc-dfc2f9dadf34
# ╠═76822162-51bd-11eb-1b85-69b19e545cf3
# ╠═88eef78a-51bd-11eb-1cd1-679f51940bc5
# ╟─39392c38-51b8-11eb-1da7-2b6638135adc
# ╠═094d1a04-51b8-11eb-3f63-2bda58300a7e
# ╠═1553bf7c-51b8-11eb-29ce-51462fc49142
# ╠═37a2afb6-51b8-11eb-06bc-db2022524f7e
# ╠═54e3b5de-51b8-11eb-0030-617b1cc35903
# ╟─9b4ca878-51b8-11eb-08dc-6f6e3aed636f
# ╟─f10b0e66-51eb-11eb-190b-2f7f45040be0
# ╟─6bcf6a62-51b9-11eb-0fbd-6f5d321dbbb7
# ╟─581a480c-5222-11eb-3781-a50c3a34864d
# ╠═72b7015a-51b9-11eb-3da0-dba937549c44
# ╟─e8ad9c22-51e4-11eb-1b6b-fd8a1c5f4527
# ╠═f07e0ac2-51e4-11eb-0ea6-237a247c5e0f
# ╠═e8960a46-51e5-11eb-1b8f-d95229f8b906
# ╠═749497ac-51e7-11eb-143a-6dad80e8f9f8
# ╟─4a19fca2-51b9-11eb-09ed-55ee5e69be3c
# ╠═54425724-51b9-11eb-3b7f-717740da73fc
# ╠═9809780c-51b9-11eb-3975-c18463dbf1ec
# ╠═d3e41376-51e8-11eb-0e3d-6fbb1739d034
# ╠═48625252-51bd-11eb-327d-332ae52bf5e3
# ╟─848c1b6a-51ee-11eb-317f-1d7e4c443b98
# ╠═8d275ca8-51ee-11eb-06e1-6bc751c15f7b
# ╠═d999e786-51ee-11eb-134f-3792f1f98df0
# ╠═353bf98a-51ef-11eb-3f78-47fd4373a62f
# ╟─86e32ef4-51e3-11eb-1000-fd4b2c287321
# ╠═cadd4cd6-51e6-11eb-2a22-c1a667903860
# ╠═b67d8fd8-51e3-11eb-0fbd-756e8be573ec
# ╠═0f2e145e-51e9-11eb-3e51-89ca54c5f210
# ╟─1bfb8e8e-526e-11eb-0ada-4feaff136226
# ╠═f883f6c2-52aa-11eb-18cc-81315890d01a
# ╟─fe26e9c6-51ff-11eb-0fc4-418824ff1e15
# ╟─04dd1cda-52b0-11eb-1b3c-c755f4479093
# ╠═e1a97074-51e7-11eb-2450-95bc85909f6a
# ╠═e1287262-52af-11eb-38f0-bd2b81d20b07
# ╠═3dc903ae-52ad-11eb-05d3-e170d123bf2c
# ╟─9b6baae0-52b0-11eb-0107-7b2fd25a90d8
# ╠═ebc85048-52af-11eb-11ce-433503934c45
# ╠═25e00ed6-520f-11eb-160a-7d4e29a923d3
# ╠═86bc1082-51ff-11eb-1682-2da0aad901a6
