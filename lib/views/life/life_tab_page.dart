import 'package:flutter/material.dart';
import '../shared/app_segmented_control.dart';
import '../shared/app_text_styles.dart';
import 'your_time_section.dart';
import 'important_people_section.dart';

/// 人生タブ（セグメンテッドコントロール付き）
class LifeTabPage extends StatefulWidget {
  const LifeTabPage({super.key});

  @override
  State<LifeTabPage> createState() => _LifeTabPageState();
}

class _LifeTabPageState extends State<LifeTabPage> {
  _LifeSegment _segment = _LifeSegment.time;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 48, 20, 130),
        child: Column(
          children: [
            Text('YOUR TIME', style: AppTextStyles.labelUppercase),
            const SizedBox(height: 24),
            Center(
              child: AppSegmentedControl<_LifeSegment>(
                items: const [
                  SegmentItem(value: _LifeSegment.time, label: 'あなた'),
                  SegmentItem(value: _LifeSegment.people, label: '大切な人'),
                ],
                selectedValue: _segment,
                onChanged: (v) => setState(() => _segment = v),
              ),
            ),
            const SizedBox(height: 28),
            if (_segment == _LifeSegment.time)
              const YourTimeSection()
            else
              const ImportantPeopleSection(),
          ],
        ),
      ),
    );
  }
}

enum _LifeSegment { time, people }
