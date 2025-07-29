// lib/presentation/bus/pages/bus_demo_page.dart

import 'package:dhaka_bus/features/bus_management/presentation/presenter/bus_presenter.dart';
import 'package:dhaka_bus/features/bus_management/presentation/presenter/bus_ui_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dhaka_bus/core/base/base_presenter.dart';
import 'package:dhaka_bus/core/di/service_locator.dart';

class BusDemoPage extends StatefulWidget {
  const BusDemoPage({super.key});

  @override
  State<BusDemoPage> createState() => _BusDemoPageState();
}

class _BusDemoPageState extends State<BusDemoPage> {
  late final BusPresenter _presenter;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _busIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load presenter using your loadPresenter function
    _presenter = loadPresenter<BusPresenter>(locate<BusPresenter>());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _busIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🚌 Bus Demo Page'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        final BusUiState state = _presenter.uiState.value;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Loading indicator
                if (state.isLoading) const LinearProgressIndicator(),

                const SizedBox(height: 16),

                // Action buttons
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _presenter.loadAllBuses(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Load All Buses'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _presenter.loadActiveBuses(),
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Active Buses'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _presenter.refreshAllData(),
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Refresh All'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Search section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '🔍 Search Buses',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: const InputDecoration(
                                  labelText: 'Search by name (English/Bengali)',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                if (_searchController.text.isNotEmpty) {
                                  _presenter.searchBuses(
                                    _searchController.text,
                                  );
                                }
                              },
                              child: const Text('Search'),
                            ),
                          ],
                        ),
                        if (state.isSearchMode) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                'Search Results: ${state.searchResults.length}',
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () => _presenter.clearSearch(),
                                child: const Text('Clear'),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Get by ID section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '🎯 Get Bus by ID',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _busIdController,
                                decoration: const InputDecoration(
                                  labelText: 'Enter Bus ID',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                if (_busIdController.text.isNotEmpty) {
                                  _presenter.loadBusById(_busIdController.text);
                                }
                              },
                              child: const Text('Get Bus'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Service type buttons
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '🚌 Filter by Service Type',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            ElevatedButton(
                              onPressed: () =>
                                  _presenter.loadBusesByServiceType('AC'),
                              child: const Text('AC Buses'),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  _presenter.loadBusesByServiceType('Non-AC'),
                              child: const Text('Non-AC Buses'),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  _presenter.loadBusesByServiceType('Express'),
                              child: const Text('Express Buses'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Data summary
                Card(
                  color: Colors.grey.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '📊 Data Summary',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Total Buses: ${state.allBuses.length}'),
                        Text('Active Buses: ${state.activeBuses.length}'),
                        if (state.isSearchMode)
                          Text('Search Results: ${state.searchResults.length}'),
                        if (state.selectedBus != null)
                          Text('Selected Bus: ${state.selectedBus!.busNameEn}'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Instructions
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ℹ️ Instructions:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• Click "Load All Buses" to see all bus data in console',
                      ),
                      Text('• Use search to find specific buses'),
                      Text('• Enter Bus ID to get specific bus details'),
                      Text('• Filter by service type to see categorized buses'),
                      Text(
                        '• Check the console (dart:developer log) for printed data',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
