
jQuery(document).ready ->
	
	#Initialize AutoGrow plugin

	jQuery -> 
		$('body textarea').autosize()

	jQuery ->
		$('#form-register').validate();

	return
