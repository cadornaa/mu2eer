ALL_CLEAN += acnet_clean
ALL_TARGETS +=
ALL_TEST += acnet_tests

acnet: acnet_adc

acnet_adc: ACNET/ADCDevice.o adc/IADCDriver.o adc/ADCDriverStub.o ACNET/adc_fef_init.o
	$(CXX) $(EES_ERL_LIBS)/cdev-1.2/priv/fef_driver_lib.o output/target/adc/ADCDriverStub.o output/target/ACNET/adc_fef_init.o output/target/ACNET/ADCDevice.o output/target/adc/IADCDriver.o -o output/target/ACNET/acnet_adc $(EES_LDFLAGS) $(DEV_OBJS) -L$(MYLIBS) $(DEV_LIBS) -lerl_interface -lei

acnet_clean:
	-rm -f ACNET/*.o
	-rm -f output/host/ACNET/*.o
	-rm -f output/target/ACNET/*.o
	-rm -f output/host/ACNET/adc_acsys
	-rm -f output/target/ACNET/adc_acsys
	-rm -f output/host/ACNET/tests
	-rm -f output/target/ACNET/tests

acnet_tests: ACNET/ADCDevice.o ACNET/ADCDeviceTest.o ACNET/AllTests.o adc/IADCDriver.o adc/ADCDriverStub.o
	$(HOST_CXX) output/host/ACNET/ADCDevice.o output/host/ACNET/ADCDeviceTest.o output/host/ACNET/AllTests.o output/host/adc/IADCDriver.o output/host/adc/ADCDriverStub.o -o output/host/ACNET/acnet_tests $(EES_LDFLAGS) $(DEV_OBJS) -L{$MYLIBS} $(DEV_LIBS) $(TEST_FLAGS)
	./output/host/ACNET/acnet_tests