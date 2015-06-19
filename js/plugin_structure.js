(function ($) {

    //create new variable from existing slick_chooser on global namespace
    // or create new empty object
    var slick_chooser = window.slick_chooser || {};


    slick_chooser = (function () { //creates isolated namespace for plugin logic.
        var default_settings = {
            'block' : 'xennsoft_checkout/onepage_product_chooser'
        };

	//constructor goes here
        var slick_chooser = function (obj, settings) {
		//constructor stuff
            var settings_to_use = $.extend(settings, default_settings);
            obj = $(obj);
            buildStructure(obj, settings_to_use);
            this.slick = jQuery(obj).slick(settings_to_use);

	    this.example_function = function(args) {
	 	//one style of public function
	    }

        }
        var self = slick_chooser;

	//equivalent to private function
        function buildStructure(obj, settings) {
            obj.html('loading ... please wait');
            $.ajax({
                data: {'block': settings.block, 'translations': settings.translations},
                type : 'POST',
                url: '/store/xennsoft/index/getBlockHtml',
                success: function(data) {
                    $(obj).html(data);
                }
            })
        }

        return slick_chooser;
    }());


//public function style two
    slick_chooser.prototype.buil = function (args) {
        alert('made it');
    }

//attach to jquery namespace
    $.fn.slick_chooser = function () {
        var parent = this;
        opt = arguments[0]; //either the init argument or the public method to be called

	/*
	this is an array of elements matched by the selector that instantiated the plugin
          So for example
		jQuery(".some-button").do_someththing(); //there could be several elements with that class on the page
                  The .each below will iterate on the array found. 
        */
        parent.each(function () { //for this example you could have multiple instances of plugin on page, if this is not intended behave then only instantiate for first 
           //element in the array
            if (typeof(opt) == 'object' || typeof(opt) == 'undefined') {
                this.slick = new slick_chooser(this, opt); //init either with nothing or object as first agument
            } else {
		//basically if the first argument is not a object and not undefined then assume
                //that we are calling a public method on plugin
                args = Array.prototype.slice.call(arguments, 1); //remove first argument as this was the name of the method
                //this call to slice removes the command from the arguments
                this.slick[opt].apply(this, args); //take the object declared and call the method indicated by opt
            }
        });
        return this; //this makes chaining works.
    }

}(jQuery))
