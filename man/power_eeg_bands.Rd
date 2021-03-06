% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/power_eeg_bands.R
\name{power_eeg_bands}
\alias{power_eeg_bands}
\title{Get power values for EEG bands}
\usage{
power_eeg_bands(
  eeg_signal,
  sampling_frequency = 125,
  max_frequency = 32,
  num_sec_w = 5,
  aggreg_level = 6
)
}
\arguments{
\item{eeg_signal}{EEG signal expressed in micro-Volts}

\item{sampling_frequency}{Sampling frequency of the EEG signal. This is 
typically equal to 125Hz. Default value is 125.}

\item{max_frequency}{The maximum frequency for which the spectrum is being 
calculated. Default value is 32.}

\item{num_sec_w}{number of seconds in a time window used to 
obtain the Fourier coefficients. Typically, this number is 5}

\item{aggreg_level}{number of 5 second intervals used to aggregate
power. Typically, this number is 6 to ensure a 30 second 
interval window (standard in EEG analysis)}
}
\value{
List containing the aggregated power values for each EEG band
}
\description{
Calculate power values for 
each of the EEG bands:
    Delta	< 4
    Theta	>=4 and < 8
    Alpha	>= 8 and < 14
    Beta	  >= 14 and < 32
    Gamma  >= 32 and < 50
}
