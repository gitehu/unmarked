## Adapted this from Rcpp package

pkg <- "unmarked"

if(require("RUnit", quietly = TRUE)) {

    is_local <- function(){
    	if( exists( "argv", globalenv() ) && "--local" %in% argv ) return(TRUE)
    	if( "--local" %in% commandArgs(TRUE) ) return(TRUE)
    	FALSE
    }
    if( is_local() ) path <- getwd()

    library(package=pkg, character.only = TRUE)
    if(!(exists("path") && file.exists(path)))
        path <- system.file("unitTests", package = pkg)

    ## --- Testing ---

    ## Define tests
    testSuite <- defineTestSuite(name=paste(pkg, "unit testing"),
                                 dirs = path,
                                 rngKind="Mersenne-Twister",
                                 rngNormalKind="Inversion")

    if(interactive()) {
        cat("Now have RUnit Test Suite 'testSuite' for package '", pkg,
            "' :\n", sep='')
        str(testSuite)
        cat('', "Consider doing",
            "\t  tests <- runTestSuite(testSuite)", "\nand later",
            "\t  printTextProtocol(tests)", '', sep="\n")
    } else { ## run from shell / Rscript / R CMD Batch / ...
        ## Run
        tests <- runTestSuite(testSuite)

        output <- NULL

        process_args <- function(argv){
        	if( !is.null(argv) && length(argv) > 0 ){
        		rx <- "^--output=(.*)$"
        		g  <- grep( rx, argv, value = TRUE )
        		if( length(g) ){
        			sub( rx, "\\1", g[1L] )
        		}
        	}
        }

        # give a chance to the user to customize where he/she wants
        # the unit tests results to be stored with the --output= command
        # line argument
        if( exists( "argv",  globalenv() ) ){
        	# littler
        	output <- process_args(argv)
        } else {
        	# Rscript
        	output <- process_args(commandArgs(TRUE))
        }

        # if it did not work, try to use /tmp
        if( is.null(output) ){
        	if( file.exists( "/tmp" ) ){
        		output <- "/tmp"
        	} else{
        		output <- getwd()
        	}
        }

        ## Print results
        output.txt  <- file.path( output, sprintf("%s-unitTests.txt", pkg))
        output.html <- file.path( output, sprintf("%s-unitTests.html", pkg))

        printTextProtocol(tests, fileName=output.txt)
        message( sprintf( "saving txt unit test report to '%s'", output.txt ) )

        ## Print HTML version to a file
        ## printHTMLProtocol has problems on Mac OS X
        if (Sys.info()["sysname"] != "Darwin"){
        	message( sprintf( "saving html unit test report to '%s'", output.html ) )
        	printHTMLProtocol(tests, fileName=output.html)
        }

        ##  stop() if there are any failures i.e. FALSE to unit test.
        ## This will cause R CMD check to return error and stop
        if(getErrors(tests)$nFail > 0) {
            stop("one of the unit tests failed")
        }
    }
} else {
    cat("R package 'RUnit' cannot be loaded -- no unit tests run\n",
    "for package", pkg,"\n")
}




tests <- runTestSuite(testSuite)
printTextProtocol(tests)
