/**
 * adc_fef_init.C
 *
 * This file contains the Acsys C++ driver entry point for acnet_adc.
 *
 * @author jdiamond
 */

#include <syslog.h>

#include "../adc/ADCDriverStub.H"
#include "ADCDevice.H"

using namespace Mu2eER;

extern void register_dev( DeviceBase* );

/**
 * Acsys Initialization Routine
 *
 * Registers our devices with the local Acsys process.
 *
 * @param int argc Argument count
 * @param char** argv Argument vector
 * @return int Return status
 */
int fef_init( int argc, char* argv[] )
{
  try
    {
      // Register devices
      // Note: we're using the ADCDriverStub until the real ADCDriver is implemented
      register_dev( new ADCDevice( unique_ptr<IADCDriver>( new ADCDriverStub() ) ) );
      
      syslog( LOG_INFO, "acnet_adc started" );
    }
  catch( const runtime_error& e )
    {
      syslog( LOG_ERR, "runtime_error caught in acnet_adc: %s", e.what() );
      throw e;
    }

  return 0;
}
