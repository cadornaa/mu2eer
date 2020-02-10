API_HOST_OUT   = $(HOST_BIN_DIR)/api
API_TARGET_OUT = $(TARGET_BIN_DIR)/api

ALL_CLEAN       += api_clean
ALL_TARGETS     += $(HOST_BIN_DIR)/api.a $(TARGET_BIN_DIR)/api.a
ALL_TEST        += api_tests
ALL_OUT         += $(API_HOST_OUT) $(API_TARGET_OUT)
ALL_SOURCES     += $(wildcard api/*.C)
ALL_HEADERS     += $(wildcard api/*.H)

API_OBJS        = SharedMemoryManager.o SpillStateMachineSMB.o SharedMemoryClient.o
API_OBJS_PREFIX = $(addprefix api/,$(API_OBJS))
API_OBJS_HOST   = $(addprefix $(API_HOST_OUT)/,$(API_OBJS))
API_OBJS_TARGET = $(addprefix $(API_TARGET_OUT)/,$(API_OBJS))

API_TEST_OBJS   = AllTests.o SharedMemoryManagerTests.o SharedMemoryClientTests.o
API_TEST_OBJS_PREFIX = $(addprefix api/,$(API_TEST_OBJS))
API_TEST_OBJS_HOST = $(addprefix $(API_HOST_OUT)/,$(API_TEST_OBJS))

ALL_COVERAGE    += $(API_OBJS_HOST)

$(API_TARGET_OUT):
	$(EES_OUT) mkdir -p $(API_TARGET_OUT)

$(API_HOST_OUT): 
	$(EES_OUT) mkdir -p $(API_HOST_OUT)

api_clean:
	$(EES_OUT) rm -f api/*.o

# Host api library
$(HOST_BIN_DIR)/api.a: $(API_OBJS_PREFIX)
	@echo "-m-> Linking $@ (host)..."
	$(EES_OUT) $(HOST_AR) ru $@ $(API_OBJS_HOST)
	$(EES_OUT) $(HOST_RANLIB) $@

# Target api library
$(TARGET_BIN_DIR)/api.a: $(API_OBJS_PREFIX)
	@echo "-m-> Linking $@ (target)..."
	$(EES_OUT) $(AR) ru $@ $(API_OBJS_TARGET)
	$(EES_OUT) $(RANLIB) $@

# Unit test suite
api_tests: $(HOST_BIN_DIR)/api.a $(API_TEST_OBJS_PREFIX)
	@echo "-m-> Linking $@ (host)..."
	$(EES_OUT) $(HOST_CXX) -o $(API_HOST_OUT)/api_tests \
		$(API_TEST_OBJS_HOST) \
		$(HOST_BIN_DIR)/api.a \
		$(DEV_LIBS) $(TEST_FLAGS)
	@echo "-m-> Running $@..."
	@./$(API_HOST_OUT)/api_tests
