% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cnd.R
\name{abort}
\alias{abort}
\alias{warn}
\alias{inform}
\alias{signal}
\alias{interrupt}
\title{Signal an error, warning, or message}
\usage{
abort(message, .subclass = NULL, ..., trace = NULL, call = NULL,
  parent = NULL, msg, type)

warn(message, .subclass = NULL, ..., call = NULL, msg, type)

inform(message, .subclass = NULL, ..., call = NULL, msg, type)

signal(message, .subclass, ..., call = NULL)

interrupt()
}
\arguments{
\item{message}{The message to display.}

\item{.subclass}{Subclass of the condition. This allows your users
to selectively handle the conditions signalled by your functions.}

\item{...}{Additional data to be stored in the condition object.}

\item{trace}{A \code{trace} object created by \code{\link[=trace_back]{trace_back()}}.}

\item{call}{Whether to display the call. If a number \code{n}, the call
is taken from the nth frame on the \link[=call_stack]{call stack}.}

\item{parent}{A parent condition object created by \code{\link[=abort]{abort()}}.}

\item{msg, type}{These arguments were renamed to \code{message} and
\code{.type} and are deprecated as of rlang 0.3.0.}
}
\description{
These functions are equivalent to base functions \code{\link[base:stop]{base::stop()}},
\code{\link[base:warning]{base::warning()}} and \code{\link[base:message]{base::message()}}, but make it easy to supply
condition metadata:
\itemize{
\item Supply \code{.subclass} to create a classed condition. Typed
conditions can be captured or handled selectively, allowing for
finer-grained error handling.
\item Supply metadata with named \code{...} arguments. This data will be
stored in the condition object and can be examined by handlers.
}

\code{interrupt()} allows R code to simulate a user interrupt of the
kind that is signalled with \code{Ctrl-C}. It is currently not possible
to create custom interrupt condition objects.
}
\section{Call trace}{


Unlike \code{stop()} and \code{warning()}, these functions don't include call
information by default. This saves you from typing \code{call. = FALSE}
and produces cleaner error messages.
}

\section{Mufflable conditions}{


Signalling a condition with \code{inform()} or \code{warn()} causes a message
to be displayed in the console. These messages can be muffled with
\code{\link[base:suppressMessages]{base::suppressMessages()}} or \code{\link[base:suppressWarnings]{base::suppressWarnings()}}.

On recent R versions (>= R 3.5.0), interrupts are typically
signalled with a \code{"resume"} restart. This is however not
guaranteed.
}

\section{Lifecycle}{


These functions were changed in rlang 0.3.0 to take condition
metadata with \code{...}. Consequently:
\itemize{
\item All arguments were renamed to be prefixed with a dot, except for
\code{type} which was renamed to \code{.subclass}.
\item \code{.call} (previously \code{call}) can no longer be passed positionally.
}
}

\examples{
# These examples are guarded to avoid throwing errors
if (FALSE) {

# Signal an error with a message just like stop():
abort("Something bad happened")

# Give a class to the error:
abort("Something bad happened", "somepkg_bad_error")

# This will allow your users to handle the error selectively
tryCatch(
  somepkg_function(),
  somepkg_bad_error = function(err) {
    warn(err$message) # Demote the error to a warning
    NA                # Return an alternative value
  }
)

# You can also specify metadata that will be stored in the condition:
abort("Something bad happened", "somepkg_bad_error", data = 1:10)

# This data can then be consulted by user handlers:
tryCatch(
  somepkg_function(),
  somepkg_bad_error = function(err) {
    # Compute an alternative return value with the data:
    recover_error(err$data)
  }
)

# If you call low-level APIs it is good practice to catch technical
# errors and rethrow them with a more meaningful message. Pass on
# the caught error as `parent` to get a nice decomposition of
# errors and backtraces:
file <- "http://foo.bar/baz"
tryCatch(
  download(file),
  error = function(err) {
    msg <- sprintf("Can't download `\%s`", file)
    abort(msg, parent = err)
})

}
}
