function [ n_data, alpha, beta, x, fx ] = weibull_cdf_values ( n_data )

%% WEIBULL_CDF_VALUES returns some values of the Weibull CDF.
%
%  Discussion:
%
%    In Mathematica, the function can be evaluated by:
%
%      Needs["Statistics`ContinuousDistributions`"]
%      dist = WeibullDistribution [ alpha, beta ]
%      CDF [ dist, x ]
%
%  Modified:
%
%    19 September 2004
%
%  Author:
%
%    John Burkardt
%
%  Reference:
%
%    Milton Abramowitz and Irene Stegun,
%    Handbook of Mathematical Functions,
%    US Department of Commerce, 1964.
%
%    Stephen Wolfram,
%    The Mathematica Book,
%    Fourth Edition,
%    Wolfram Media / Cambridge University Press, 1999.
%
%  Parameters:
%
%    Input/output, integer N_DATA.  The user sets N_DATA to 0 before the
%    first call.  On each call, the routine increments N_DATA by 1, and
%    returns the corresponding data; when there is no more data, the
%    output value of N_DATA will be 0 again.
%
%    Output, real ALPHA, the first parameter of the distribution.
%
%    Output, real BETA, the second parameter of the distribution.
%
%    Output, real X, the argument of the function.
%
%    Output, real FX, the value of the function.
%
  n_max = 12;

  alpha_vec = [ ...
     0.1000000000000000E+01, ...  
     0.1000000000000000E+01, ...  
     0.1000000000000000E+01, ...  
     0.1000000000000000E+01, ...  
     0.1000000000000000E+01, ...  
     0.1000000000000000E+01, ...  
     0.1000000000000000E+01, ...  
     0.1000000000000000E+01, ...  
     0.2000000000000000E+01, ...  
     0.3000000000000000E+01, ...  
     0.4000000000000000E+01, ...  
     0.5000000000000000E+01 ]; 

  beta_vec = [ ...
     0.5000000000000000E+00, ...  
     0.5000000000000000E+00, ...
     0.5000000000000000E+00, ...
     0.5000000000000000E+00, ...
     0.2000000000000000E+01, ...
     0.3000000000000000E+01, ...
     0.4000000000000000E+01, ...
     0.5000000000000000E+01, ...
     0.2000000000000000E+01, ...
     0.2000000000000000E+01, ...
     0.2000000000000000E+01, ...
     0.2000000000000000E+01 ];

  fx_vec = [ ...
     0.8646647167633873E+00, ...
     0.9816843611112658E+00, ...
     0.9975212478233336E+00, ...
     0.9996645373720975E+00, ...
     0.6321205588285577E+00, ...
     0.4865828809674080E+00, ...
     0.3934693402873666E+00, ...
     0.3296799539643607E+00, ...
     0.8946007754381357E+00, ...
     0.9657818816883340E+00, ...
     0.9936702845725143E+00, ...
     0.9994964109502630E+00 ];

  x_vec = [ ...
     0.1000000000000000E+01, ...  
     0.2000000000000000E+01, ...  
     0.3000000000000000E+01, ...  
     0.4000000000000000E+01, ...  
     0.2000000000000000E+01, ...  
     0.2000000000000000E+01, ...  
     0.2000000000000000E+01, ...  
     0.2000000000000000E+01, ...  
     0.3000000000000000E+01, ...  
     0.3000000000000000E+01, ...  
     0.3000000000000000E+01, ...  
     0.3000000000000000E+01 ];

  if ( n_data < 0 )
    n_data = 0;
  end

  n_data = n_data + 1;

  if ( n_max < n_data )
    n_data = 0;
    alpha = 0.0;
    beta = 0.0;
    x = 0.0;
    fx = 0.0;
  else
    alpha = alpha_vec(n_data);
    beta = beta_vec(n_data);
    x = x_vec(n_data);
    fx = fx_vec(n_data);
  end

