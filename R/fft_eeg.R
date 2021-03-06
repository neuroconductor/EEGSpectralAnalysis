#' @title Compute EEG signal parameters
#' 
#' @description Calculate absolute and power spectrum as well as estimated and 
#'   lowest frequencies for an EEG signal
#'
#' @param eeg_signal EEG signal expressed in micro-Volts
#' @param sampling_frequency Sampling frequency of the EEG signal. This is 
#'   typically equal to 125Hz. Default value is 125.
#' @param max_frequency The maximum frequency for which the spectrum is being 
#'   calculated. Default value is 32.
#' @param num_seconds_window the duration of EEG record used for analysis (in seconds) per window
#'   
#' @return List containing the elements:
#'   - absolute_spectrum:    A matrix with every row corresponding to
#'                           a frequency between 'lowest_frequency' and
#'                           'max_frequency'. Every column corresponds
#'                           to a 5 second interval. Every entry is the
#'                           absolute value of the Fourier coefficient
#'
#'   - power_spectrum:       Same structure as 'absolute_spectrum', but
#'                           contains the square of the absolute value
#'                           of the Fourier coefficient
#'
#'   - estimated_frequencies: Vector of estimated frequencies
#'                            corresponding to each row in the spectrum
#'                            matrices
#'
#'   - lowest_frequency:     The smallest estimable frequency. This is
#'                           also the first entry of 'estimated_frequencies'
#'   
#' @importFrom stats fft
#' @importFrom utils read.table     
#' @importFrom signal hanning   
#' @export
fft_eeg = function(eeg_signal,
                   sampling_frequency = 125,
                   max_frequency = 32,
                   num_seconds_window = 5) {
  
  eeg_signal <- eeg_signal * 1000000
  length_record <- length(eeg_signal)
  
  #This is the number of datapoints in each 'window' which will be used for the FFT
  window_length <- num_seconds_window*sampling_frequency;
  
  #Lowest frequency that can be estimated based on the num_seconds_window
  lowest_frequency <- 1/num_seconds_window;   
  
  
  #Number of windows (that are in length = recdur) for which the FFT will be calculated;             
  num_windows <- floor(length_record/window_length);
  
  eeg_signal <- matrix(eeg_signal,window_length, num_windows)
  
  #Perform the fft on the data after hanning windowing
  eeg_signal <- scale(eeg_signal,scale=FALSE)
  hanning_matrix <- hanning(window_length+2)
  hanning_matrix <- hanning_matrix[1:window_length+1]
  hanning_matrix <- hanning_matrix * matrix(1,window_length,num_windows)
  
  eeg_signal <- eeg_signal * hanning_matrix
  eeg_signal <- apply(eeg_signal, 2, function(x) fft(as.numeric(x)))
  
  #Calculate the absolute 
  #This is the calculation of power of the spectrum 
  
  end_frequency <- floor(max_frequency*num_seconds_window) + 1
  absolute_spectrum <- abs(eeg_signal[1:end_frequency,])
  power_spectrum <- absolute_spectrum^2
  estimated_frequencies <- seq(1,end_frequency,1)/num_seconds_window
  
  output <- list(absolute_spectrum,power_spectrum,estimated_frequencies,lowest_frequency,num_seconds_window,sampling_frequency)
  names(output) <- c("absolute_spectrum","power_spectrum","estimated_frequencies","lowest_frequency","num_seconds_window","sampling_frequency")
  
  return(output)
}