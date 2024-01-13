function F = CIRPrice(parameters, spotsRate, maturity)
    r_ave_star = parameters(1);
    gamma_star = parameters(2);
    alpha = parameters(3);
    F = exp(Afunction(r_ave_star, gamma_star, alpha, maturity) - Bfunction(r_ave_star, gamma_star, alpha, maturity) .* spotsRate);
end