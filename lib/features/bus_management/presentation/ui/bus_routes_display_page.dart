import 'package:dhaka_bus/core/config/app_screen.dart';
import 'package:dhaka_bus/core/di/service_locator.dart';
import 'package:dhaka_bus/core/external_libs/user_input_field/src/user_input_field_widget.dart';
import 'package:dhaka_bus/core/static/svg_path.dart';
import 'package:dhaka_bus/core/static/ui_const.dart';
import 'package:dhaka_bus/core/widgets/presentable_widget_builder.dart';
import 'package:dhaka_bus/features/bus_management/presentation/presenter/bus_presenter.dart';
import 'package:dhaka_bus/features/bus_management/presentation/widgets/swap_button.dart';
import 'package:dhaka_bus/features/bus_management/presentation/widgets/bus_route_card_widget.dart';
import 'package:dhaka_bus/shared/components/custom_app_bar_widget.dart';
import 'package:flutter/material.dart';

class BusRoutesDisplayPage extends StatelessWidget {
  BusRoutesDisplayPage({super.key});
  final BusPresenter busPresenter = locate<BusPresenter>();

  @override
  Widget build(BuildContext context) {
    return PresentableWidgetBuilder(
      presenter: busPresenter,
      builder: () => Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: CustomAppBar(title: '🚌 Bus & Routes', isRoot: true),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Search Input Section
            SizedBox(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: twentyPx,
                      vertical: tenPx,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildInputField(
                          hintText: 'Enter starting station name',
                          textEditingController:
                              busPresenter.startingStationNameController,
                        ),
                        gapH16,
                        _buildInputField(
                          hintText: 'Enter destination station name',
                          textEditingController:
                              busPresenter.destinationStationNameController,
                        ),
                      ],
                    ),
                  ),
                  SwapButton(busPresenter: busPresenter),
                ],
              ),
            ),

            // Bus Routes List Section
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  BusRouteCard(
                    id: 'ahim_transport_1',
                    title: 'আহিম পরিবহন',
                    route: 'সাভারগঞ্জ ↔ ঢাকা ১৭নং টেকনিক্যাল',
                    description:
                        'সাভারগঞ্জ → টেকনিক্যাল → আলমগীর শরণার্থী শিবির → নিউ মার্কেট → কার পার্ট সিটি কর → দিলকুশা → পোস্ট অফিস → বিরুলিয়া ↔ শহীদুল্লাহ মোড় ↔ রূপনগর → পূর্ণিমা ↔ নবীনগর → নবীনগর ↔ বিমানবন্দর → উত্তরা কলেজ → সাভার কলেজ → বাংলাদেশ → শহীদ সালাম ↔ ঢাকা ১৭নং টেকনিক্যাল',
                    cardColor: Colors.blue,
                    busTime: 'প্রতি ১৫ মিনিট অন্তর',
                    fare: '৳২৫-৪৫',
                    isExpanded: busPresenter.isCardExpanded('ahim_transport_1'),
                    onTap: () =>
                        busPresenter.toggleCardExpansion('ahim_transport_1'),
                  ),
                  BusRouteCard(
                    id: 'hsht_transport_1',
                    title: 'এইচিত পরিবহন',
                    route: 'শিয়া কমপ্লিট ↔ আমতলার',
                    description:
                        'শিয়া কমপ্লিট → বাজার → স্কুল কলেজ → হাসপাতাল → পার্ক → মসজিদ রোড় → আমতলার বাস স্ট্যান্ড। আরামদায়ক যাত্রা ও নিয়মিত সেবা।',
                    cardColor: Colors.orange,
                    busTime: 'সকাল ৬টা - রাত ১০টা',
                    fare: '৳২০-৩৫',
                    isExpanded: busPresenter.isCardExpanded('hsht_transport_1'),
                    onTap: () =>
                        busPresenter.toggleCardExpansion('hsht_transport_1'),
                  ),
                  BusRouteCard(
                    id: 'adommo_transport_1',
                    title: 'অদম্য',
                    route: 'সাগর ↔ নতুন বাজার',
                    description:
                        'সাগর পার → রেলস্টেশন → পুরান বাজার → ব্যাংক রোড় → হাসপাতাল → স্কুল → নতুন বাজার। দ্রুত ও নিরাপদ পরিবহন সেবা।',
                    cardColor: Colors.green,
                    busTime: 'প্রতি ২০ মিনিট অন্তর',
                    fare: '৳১৫-৩০',
                    isExpanded: busPresenter.isCardExpanded(
                      'adommo_transport_1',
                    ),
                    onTap: () =>
                        busPresenter.toggleCardExpansion('adommo_transport_1'),
                  ),
                  BusRouteCard(
                    id: 'egaro_bashundhara_1',
                    title: 'এগারোশত বসুন্ধরা এভিনিউ',
                    route: 'কুমারটুলি ↔ আজমপুর',
                    description:
                        'কুমারটুলি → শিল্পকলা একাডেমি → শাহবাগ → কলাবাগান → ধানমন্ডি → আজমপুর। শহরের প্রধান এলাকাগুলির সাথে যোগাযোগ।',
                    cardColor: Colors.red,
                    busTime: 'সকাল ৫:৩০ - রাত ১১টা',
                    fare: '৳২৫-৫০',
                    isExpanded: busPresenter.isCardExpanded(
                      'egaro_bashundhara_1',
                    ),
                    onTap: () =>
                        busPresenter.toggleCardExpansion('egaro_bashundhara_1'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  UserInputField _buildInputField({
    required String hintText,
    required TextEditingController textEditingController,
  }) {
    return UserInputField(
      contentPadding: EdgeInsets.symmetric(vertical: 10),
      hintText: hintText,
      fillColor: Color(0xffEEEEEE),
      prefixIconPath: SvgPath.icSearch,
      textEditingController: textEditingController,
    );
  }
}
