@scenario SSA = begin
    ξ::Float64
end

@sampler SSA = begin
    w::Float64

    SSA(w::AbstractFloat) = new(w)

    @sample begin
        w = sampler.w
        return SSAScenario(w*randn(), probability = rand())
    end
end

ssa_gen = StochasticProgram(SSAScenario)

@first_stage ssa_gen = begin
    @variable(model, x >= 0)
end

@second_stage ssa_gen = begin
    @decision x
    ξ = scenario.ξ
    @variable(model, y)
    @objective(model, Min, y)
    @constraint(model, y == x)
    @constraint(model, y >= ξ)
end