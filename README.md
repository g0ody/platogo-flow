platogo-flow
============

AS3 Command Framework and much more. It evolved from a simple command framework to a framework which supports:

* __command processing__
  * serial, parallel, nested
  * utility classes for a lot of actions
  * wrapper classes for external libraries ( [greensock-api](http://www.greensock.com/v11/), [facebook-api](http://code.google.com/p/facebook-actionscript-api/), [platogo-api](http://www.platogo.com/wrapper), [parse](https://parse.com/))
  * response data processing
  * command database
*  __screen system__
  * layer support
  * screen pool
  * unique/referenced screens 
  * command classes for screen handling (show, hide, push, pop)
* __data handling__
  * data references
  * parse data from google spreadsheets (arrays and dictonaries)
  * traverse through member variables, properties, functions to access data
  * data converter
  * integrated into command framework
* __logging__
  * different log levels
  * easly connect to a logging service
  * integrated into the command framework
* __game view__
  * bitmap renderer (render everything in one bitmap)
  * different gameobject types
    * render
    * update
    * interactive(click + drag)
  * define your own gameobjects
  * full control over z-sorting
  * full control over update loop
  * supports movieclip animation

Every part of the framework (command, screen, data, log, game) can be used on its own. 

The documentation for key classes is finished, but there is still a lot to write.
[Documentation](http://g0ody.github.com/platogo-flow/)
