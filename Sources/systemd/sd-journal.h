///
/// Note this header file is used to work around the issue of having to hard code
/// the header paths in the modulemap file.  By hard coding the path to this file
/// and allow this file to use the system search path, any headers listed here will
/// be exposed to the module.
///
#import <systemd/sd-journal.h>
