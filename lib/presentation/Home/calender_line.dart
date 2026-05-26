import 'dart:ui';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_reminder/core/app/block/cubit.dart';
import 'package:medi_reminder/core/utils/app_values.dart';

class CalenderLine extends StatefulWidget {
  const CalenderLine({super.key});

  @override
  State<CalenderLine> createState() => _CalenderLineState();
}

class _CalenderLineState extends State<CalenderLine> {
  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        AppSize.s30,
      ), // smooth corners for the glass area
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 🌫️ Glassy blurred background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40), // stronger blur
            child: Container(
              height: AppHeight.h220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.35), // close to white
                borderRadius: BorderRadius.circular(AppSize.s30),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.5),
                  width: 1.2,
                ),
              ),
            ),
          ),

          // 🗓️ Your horizontal calendar
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppHeight.h20),
            child: ClipRRect(
              clipBehavior: Clip.none,
              child: EasyDateTimeLine(
                initialDate: DateTime.now(),
                onDateChange: (date) {
                  setState(() {
                    selectedDate = date;
                  });

                  context.read<MedicineCubit>().filterByDate(date);
                },
                activeColor: const Color(0xff37306B),
                headerProps: const EasyHeaderProps(
                  monthPickerType: MonthPickerType.switcher,
                  dateFormatter: DateFormatter.fullDateDMY('-'),
                ),
                dayProps: EasyDayProps(
                  activeDayStyle: DayStyle(
                    borderRadius: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppSize.s32),
                      ),
                      border: Border.all(color: Colors.white),

                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xffF7B8CD), Color(0xffF97692)],
                      ),
                    ),
                  ),
                  inactiveDayStyle: DayStyle(
                    borderRadius: AppSize.s32,
                    dayNumStyle: TextStyle(
                      fontSize: FontSize.s28,
                      fontWeight:
                          FontWeight.w800, // text color for inactive date
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      color: Color(
                        0xfff2f2f7,
                      ), // background color for inactive date
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppSize.s32),
                      ),
                    ),
                  ),
                ),
                timeLineProps: EasyTimeLineProps(
                  hPadding: AppWidth.w16,
                  separatorPadding: AppWidth.w16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
