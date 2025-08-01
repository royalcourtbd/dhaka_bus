// lib/presentation/bus/pages/bus_demo_page.dart

import 'package:dhaka_bus/core/di/service_locator.dart';
import 'package:dhaka_bus/core/widgets/presentable_widget_builder.dart';
import 'package:dhaka_bus/features/bus_management/bus_management_export.dart';
import 'package:flutter/material.dart';

class BusDemoPage extends StatelessWidget {
  BusDemoPage({super.key});
  final BusPresenter _busPresenter = locate<BusPresenter>();

  @override
  Widget build(BuildContext context) {
    return PresentableWidgetBuilder(
      presenter: _busPresenter,
      onInit: () =>
          _busPresenter.loadBusesAndRoutes(), // Load both buses and routes
      builder: () {
        return Scaffold(
          appBar: AppBar(
            title: const Text('🚌 Bus & Routes'),
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => _busPresenter.refreshAllData(),
              ),
            ],
          ),
          body: _busPresenter.currentUiState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _busPresenter.currentUiState.allBuses.isEmpty
              ? const Center(
                  child: Text(
                    'কোন বাস তথ্য পাওয়া যায়নি',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : Column(
                  children: [
                    // Summary header
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.blue.shade50,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '📊 সারসংক্ষেপ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildSummaryCard(
                                'মোট বাস',
                                '${_busPresenter.currentUiState.allBuses.length}',
                                Icons.directions_bus,
                                Colors.green,
                              ),
                              _buildSummaryCard(
                                'মোট রুট',
                                '${_busPresenter.currentUiState.allRoutes.length}',
                                Icons.route,
                                Colors.orange,
                              ),
                              _buildSummaryCard(
                                'রুটসহ বাস',
                                '${_busPresenter.currentUiState.busRoutes.keys.length}',
                                Icons.alt_route,
                                Colors.purple,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Bus list with routes
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _busPresenter.currentUiState.allBuses.length,
                        itemBuilder: (context, index) {
                          final bus =
                              _busPresenter.currentUiState.allBuses[index];
                          final routes = _busPresenter.getRoutesForBus(
                            bus.busId,
                          );
                          final routeCount = routes.length;

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            elevation: 2,
                            child: ExpansionTile(
                              leading: CircleAvatar(
                                backgroundColor: bus.isActive
                                    ? Colors.green
                                    : Colors.red,
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                bus.busNameEn,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bus.busNameBn,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.route,
                                        size: 16,
                                        color: routeCount > 0
                                            ? Colors.blue
                                            : Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '$routeCount টি রুট',
                                        style: TextStyle(
                                          color: routeCount > 0
                                              ? Colors.blue
                                              : Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      if (bus.serviceType != null)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade100,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            bus.serviceType!,
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.blue.shade800,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    bus.isActive
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color: bus.isActive
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  Text(
                                    bus.isActive ? 'সক্রিয়' : 'নিষ্ক্রিয়',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: bus.isActive
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              children: routes.isEmpty
                                  ? [
                                      const ListTile(
                                        leading: Icon(
                                          Icons.info_outline,
                                          color: Colors.grey,
                                        ),
                                        title: Text(
                                          'এই বাসের জন্য কোন রুট তথ্য নেই',
                                        ),
                                      ),
                                    ]
                                  : routes.map((route) {
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 4,
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade50,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey.shade200,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.route,
                                                  color: Colors.blue.shade600,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    'রুট আইডি: ${route.routeId}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          Colors.blue.shade800,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 2,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Colors.orange.shade100,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    '${route.totalStops} স্টপ',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors
                                                          .orange
                                                          .shade800,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (route
                                                .routeDistance
                                                .isNotEmpty) ...[
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.straighten,
                                                    color: Colors.grey.shade600,
                                                    size: 14,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    'দূরত্ব: ${route.routeDistance}',
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                            if (route.stops.isNotEmpty) ...[
                                              const SizedBox(height: 8),
                                              Text(
                                                'স্টপসমূহ:',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey.shade700,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Wrap(
                                                spacing: 4,
                                                runSpacing: 4,
                                                children: route.stops.take(5).map((
                                                  stop,
                                                ) {
                                                  return Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 6,
                                                          vertical: 2,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.blue.shade50,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      border: Border.all(
                                                        color: Colors
                                                            .blue
                                                            .shade200,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      stop,
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors
                                                            .blue
                                                            .shade700,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                              if (route.stops.length > 5)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        top: 4,
                                                      ),
                                                  child: Text(
                                                    'আরও ${route.stops.length - 5}টি স্টপ...',
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontSize: 10,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ],
                                        ),
                                      );
                                    }).toList(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
