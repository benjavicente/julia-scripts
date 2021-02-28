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

# ╔═╡ a7c82c20-fff7-11ea-29c6-29bc41a5e8ee
begin
	using DelimitedFiles
	using DataFrames
	using PlutoUI
	md"Trabajando en $(pwd())"
end

# ╔═╡ 0b60e320-fff9-11ea-2243-693f4233268f
md"""# Tarea 4: Optimización
Implementación en Julia - Benjamín Vicente Goecke
"""

# ╔═╡ a9a2025c-494c-11eb-2333-6bda3f2b1bdd
md"""
En esta tarea habia que implementar los algoritmos Fist-Fit (FF) y
Fist-Fit-Decreasing (FFD) (tambíen llamado Firs-Fist-Reverso) utilizados
para resolver el problema de embalaje de tareas recurrentes (o contenedores).

Ver [Bin packing problem](https://en.wikipedia.org/wiki/Bin_packing_problem).

Antes esta tarea estaba implementada en Python, pero el tiempo de ejecucuón
superaba los 20 minutos. En Julia es cercano al minuto. 
"""

# ╔═╡ f7fda930-fff8-11ea-3e9a-618fbaf23661
md"""## Creación de las instancias"""

# ╔═╡ 64df8860-4949-11eb-02ac-dd69ad98de12
# Tarea a asignar con c la duración y p el periodo 
struct Job
	c::Int
	p::Int
end;

# ╔═╡ 747b24b2-4949-11eb-2f58-89b292509607
# Tarea asignada con un offset a
struct AssignedJob
	c::Int
	p::Int
	a::Int
end;

# ╔═╡ 77ab40ee-0014-11eb-058b-657cf2e9caab
PATH_INSTANCES = "instancias";

# ╔═╡ 858c46a0-4938-11eb-0fce-55ce57bd3415
begin
	omit_options = Dict([
		"sin narmónico (rápido)" => ["NarmonicoDif_n40", "NarmonicoDif_n20"],
		"sin narmónico n40" => ["NarmonicoDif_n40"],
		"todas (lento)" => []
	])
	selector = @bind omit_selected_option Select(
		collect(keys(omit_options)),
		default="sin narmónico (rápido)"
	)
	md"Eliga que evaluar: $(selector)"
end

# ╔═╡ 2c4d1bb0-fff6-11ea-0250-d7b214c62124
begin
	OMIT = omit_options[omit_selected_option]
	INSTANCES = Dict{String, Array{Job}}()
	for path in readdir(PATH_INSTANCES, join=true)
		if isdir(path) & !(last(splitdir(path)) in OMIT)
			for subpath in readdir(path, join=true)
				if splitext(subpath)[2] == ".txt"
					name = splitext(basename(subpath))[1]
					data_matrix =  readdlm(subpath, Int64)
					list_of_jobs = [Job(row...) for row in eachrow(data_matrix)]
					push!(INSTANCES, name => list_of_jobs)
				end
			end
		end
	end
	md"Instancias cargadas: $(length(INSTANCES))"
end

# ╔═╡ f0bf44d0-0007-11eb-388a-afd9687ebf05
md"Ejemplo: $(@bind example Select(collect(keys(INSTANCES))))"

# ╔═╡ b3f22fa0-fff7-11ea-3884-af25f13d6a98
INSTANCES[example]

# ╔═╡ da425020-fff9-11ea-07a4-0725b090e586
md"""## Funciones de utilidad"""

# ╔═╡ 1407051e-fffb-11ea-392f-e17520d9e295
md"""### Colisiones"""

# ╔═╡ 9927f120-fffa-11ea-2963-2319f6ab1f4e
function collide(j1::AssignedJob, j2::AssignedJob)
	!(j1.c <= mod(j2.a - j1.a, gcd(j2.p, j1.p)) <= gcd(j2.p, j1.p) - j2.c)
end

# ╔═╡ fb9a9420-fffa-11ea-3729-cd3222f671b5
collide(AssignedJob(1, 3, 1), AssignedJob(2, 6, 2))

# ╔═╡ 546bda50-fffb-11ea-2146-f14ad9957185
collide(AssignedJob(2, 6, 2), AssignedJob(1, 3, 1))

# ╔═╡ 546f0e9e-fffb-11ea-07d1-9d8ebda7d3eb
collide(AssignedJob(1, 4, 1), AssignedJob(3, 5, 2))

# ╔═╡ 8c16e1a0-fffd-11ea-0c47-db351cbc7825
md"""### Función General"""

# ╔═╡ a5286c40-fffd-11ea-3e74-171539d93710
function valid(processor::Array{AssignedJob}, job1::AssignedJob)
	for job2 in processor
		if collide(job1, job2)
			return false
		end
	end
	return true
end;

# ╔═╡ d5a96a40-fffd-11ea-0eed-a9c46e458626
function common_process(jobs::Array{Job})
	processors = Array{Array{AssignedJob, 1}, 1}()
	for job in jobs
		assigned = false
		for prcs in processors
			for offset in 1:job.p
				tested_job = AssignedJob(job.c, job.p, offset)
				if !assigned & valid(prcs, tested_job)
					push!(prcs, tested_job)
					assigned = true
				end
			end
		end
		if !assigned
			push!(processors, [AssignedJob(job.c, job.p, 1)])
		end
	end
	return processors
end;

# ╔═╡ 38122cc0-ffff-11ea-2128-133a1a5a799d
md"### First-Fit (FF)"

# ╔═╡ 63939b36-493d-11eb-1ff4-7160f0c61485
function FF(jobs::Array{Job})
	common_process(sort(jobs,  by = j -> j.p, rev = false))
end;

# ╔═╡ e4fc6130-ffff-11ea-3be5-69e4e8758d6f
md"""Ejemplo"""

# ╔═╡ ea36452e-ffff-11ea-1bce-65e01f181df7
FF(INSTANCES[example])

# ╔═╡ a017a92e-ffff-11ea-026e-2b8cca1061a0
md"### First-Fit-Reverso (FFD)"

# ╔═╡ 92461032-ffff-11ea-2c98-31a21e4ad582
function FFD(jobs::Array{Job})
	common_process(sort(jobs, by = j -> j.p, rev = true))
end;

# ╔═╡ 0db56b60-0002-11eb-39be-f3176e0f6e29
FFD(INSTANCES[example])

# ╔═╡ 4238b7c0-0002-11eb-3461-7db682662b12
md"""## Testeo"""

# ╔═╡ 814cc5ce-0009-11eb-0d94-57ad06059679
function test(instances_data)
	df = DataFrame(
		name     = String[],
		lb       = Float64[],
		FF_time  = Float64[],
		FF_m     = Int64[],
		FFD_time = Float64[],
		FFD_m    = Int64[],
	)
	for (i, (name, instances)) in enumerate(pairs(instances_data))
		# LB
		lb = sum(j -> j.c / j.p, instances)

		## FF
		t = time()
		ff_result = FF(instances)
		ff_m      = length(ff_result)
		ff_time   = time() - t

		## FFD
		t = time()
		ffd_result = FFD(instances)
		ffd_m      = length(ffd_result)
		ffd_time   = time() - t

		# Imprimir en la consola (Pluto.jl creo que no soporta output dinamico)
		println(lpad(round(Int, i / length(instances_data) * 100), 3), "% ", name)

		# Guardar resultados
		push!(df, [name, lb, ff_time, ff_m, ffd_time, ffd_m])
	end
	df
end;

# ╔═╡ 4364d94a-494b-11eb-1ff7-57e594738c66
test(Dict(first(INSTANCES))); # Optimización inicial de Julia

# ╔═╡ 6387c870-000d-11eb-0c14-a97c1c89cc20
DF = test(INSTANCES);

# ╔═╡ fe5350e0-000d-11eb-1b18-8184ad418942
begin
	total_time = round(sum(DF[!, :FF_time]) + sum(DF[!, :FFD_time]), digits=2)
	instance_count = size(DF, 1)
	md"""El tiempo de ejecución total para FF y FFR fue de **$total_time segundos**
	para un total de **$instance_count instancias** (con $omit_selected_option)."""
end

# ╔═╡ f570ec60-000f-11eb-2d15-0d297fee1044
begin
	DF."FF_m/lb" = DF."FF_m" ./ DF."lb"
	DF."FFD_m/lb" = DF."FFD_m" ./ DF."lb"
	DF."FF_time/FFD_time" = DF."FF_time" ./ DF."FFD_time"
	DF
end

# ╔═╡ Cell order:
# ╟─0b60e320-fff9-11ea-2243-693f4233268f
# ╟─a7c82c20-fff7-11ea-29c6-29bc41a5e8ee
# ╟─a9a2025c-494c-11eb-2333-6bda3f2b1bdd
# ╟─f7fda930-fff8-11ea-3e9a-618fbaf23661
# ╠═64df8860-4949-11eb-02ac-dd69ad98de12
# ╠═747b24b2-4949-11eb-2f58-89b292509607
# ╠═77ab40ee-0014-11eb-058b-657cf2e9caab
# ╟─858c46a0-4938-11eb-0fce-55ce57bd3415
# ╟─2c4d1bb0-fff6-11ea-0250-d7b214c62124
# ╟─f0bf44d0-0007-11eb-388a-afd9687ebf05
# ╠═b3f22fa0-fff7-11ea-3884-af25f13d6a98
# ╟─da425020-fff9-11ea-07a4-0725b090e586
# ╟─1407051e-fffb-11ea-392f-e17520d9e295
# ╠═9927f120-fffa-11ea-2963-2319f6ab1f4e
# ╠═fb9a9420-fffa-11ea-3729-cd3222f671b5
# ╠═546bda50-fffb-11ea-2146-f14ad9957185
# ╠═546f0e9e-fffb-11ea-07d1-9d8ebda7d3eb
# ╟─8c16e1a0-fffd-11ea-0c47-db351cbc7825
# ╠═a5286c40-fffd-11ea-3e74-171539d93710
# ╠═d5a96a40-fffd-11ea-0eed-a9c46e458626
# ╟─38122cc0-ffff-11ea-2128-133a1a5a799d
# ╠═63939b36-493d-11eb-1ff4-7160f0c61485
# ╟─e4fc6130-ffff-11ea-3be5-69e4e8758d6f
# ╟─ea36452e-ffff-11ea-1bce-65e01f181df7
# ╟─a017a92e-ffff-11ea-026e-2b8cca1061a0
# ╠═92461032-ffff-11ea-2c98-31a21e4ad582
# ╠═0db56b60-0002-11eb-39be-f3176e0f6e29
# ╟─4238b7c0-0002-11eb-3461-7db682662b12
# ╠═814cc5ce-0009-11eb-0d94-57ad06059679
# ╟─4364d94a-494b-11eb-1ff7-57e594738c66
# ╠═6387c870-000d-11eb-0c14-a97c1c89cc20
# ╟─fe5350e0-000d-11eb-1b18-8184ad418942
# ╟─f570ec60-000f-11eb-2d15-0d297fee1044
