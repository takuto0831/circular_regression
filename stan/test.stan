functions{
  real circular_reg_lpdf(real theta, real pre_theta, vector alpha_0, matrix alpha_1, matrix sigma){
    vector[2] u; vector[2] tmp; vector[2] mu;
    real A; real B; real C; real D; real p;
    tmp[1] = cos(pre_theta); tmp[2] = sin(pre_theta);
    mu = alpha_0 + alpha_1 * tmp; 
    u[1] = cos(theta); u[2] = sin(theta);
    A = quad_form(inverse_spd(sigma), u); B = u' * inverse_spd(sigma) * mu;
    C = (-0.5) * quad_form(inverse_spd(sigma), mu); D = B/sqrt(A);
    p = -log(A) - 0.5*log(determinant(sigma)) + C
    + log(1+(D * normal_cdf(D,0,1)/exp(normal_lpdf(D|0,1))));    
    return p;
  }
}
//   
// data{
//   int N; // sample size
//   real<lower=0,upper=2*pi()> theta[N]; // data
// }
// 
// parameters{
//   vector[2] alpha_0;
//   matrix[2,2] alpha_1;
//   real<lower=0.0001> tau;
//   real rho;
// }
// 
// transformed parameters{
//   cov_matrix[2] sigma;
//   sigma[1,1] = tau; sigma[1,2] = sqrt(tau)*rho;
//   sigma[2,1] = sqrt(tau)*rho; sigma[2,2] = 1.0;
// }
// 
// model{
//   alpha_0 ~ multi_normal(rep_vector(0,2),diag_matrix(rep_vector(10^5,2)));
//   tau ~ inv_gamma(0.01,0.01);
//   rho ~ uniform(-1.0,1.0);
//   
//   //vector[N-1] ps;
//   for(n in 2:N){
//     theta[n] ~ circular_reg_lpdf(theta[n-1],alpha_0,alpha_1,sigma);
//   }
// }
