import 'package:uuid/uuid.dart';
import '../../features/timeline/domain/entities/timeline.dart';
import '../../features/timeline/domain/entities/timeline_event.dart';
import '../../features/timeline/domain/entities/event_type.dart';

/// Sample data utility class
class SampleData {
  static const _uuid = Uuid();

  /// Generate sample timeline data
  static List<Timeline> generateSampleTimelines() {
    return [
      _createHistoryTimeline(),
      _createBiographyTimeline(),
      _createMovieTimeline(),
    ];
  }

  /// Create history event sample
  static Timeline _createHistoryTimeline() {
    final now = DateTime.now();
    return Timeline(
      id: _uuid.v4(),
      name: '中国改革开放历程',
      description: '记录中国改革开放以来的重要历史时刻',
      category: EventType.history,
      createdAt: now,
      updatedAt: now,
      events: [
        TimelineEvent(
          id: _uuid.v4(),
          title: '十一届三中全会',
          description: '中国共产党第十一届中央委员会第三次全体会议在北京召开，标志着改革开放的开始。',
          timestamp: DateTime(1978, 12, 18),
          type: EventType.history,
          tags: ['政治', '历史转折'],
          isImportant: true,
        ),
        TimelineEvent(
          id: _uuid.v4(),
          title: '设立经济特区',
          description: '国务院批准在深圳、珠海、汕头和厦门试办经济特区。',
          timestamp: DateTime(1980, 8, 26),
          type: EventType.history,
          tags: ['经济', '特区'],
          isImportant: true,
        ),
        TimelineEvent(
          id: _uuid.v4(),
          title: '加入世界贸易组织',
          description: '中国正式成为世界贸易组织(WTO)第143个成员。',
          timestamp: DateTime(2001, 12, 11),
          type: EventType.history,
          tags: ['国际', '经济'],
          isImportant: true,
        ),
        TimelineEvent(
          id: _uuid.v4(),
          title: '北京奥运会',
          description: '第29届夏季奥林匹克运动会在北京举办，这是中国首次举办奥运会。',
          timestamp: DateTime(2008, 8, 8),
          type: EventType.history,
          tags: ['体育', '国际'],
          isImportant: true,
        ),
      ],
    );
  }

  /// Create biography sample
  static Timeline _createBiographyTimeline() {
    final now = DateTime.now();
    return Timeline(
      id: _uuid.v4(),
      name: '乔布斯生平',
      description: '苹果公司联合创始人史蒂夫·乔布斯的传奇人生',
      category: EventType.biography,
      createdAt: now,
      updatedAt: now,
      events: [
        TimelineEvent(
          id: _uuid.v4(),
          title: '出生',
          description: '史蒂夫·乔布斯出生于美国加利福尼亚州旧金山。',
          timestamp: DateTime(1955, 2, 24),
          type: EventType.biography,
          tags: ['早年'],
        ),
        TimelineEvent(
          id: _uuid.v4(),
          title: '创立苹果公司',
          description: '与史蒂夫·沃兹尼亚克和罗纳德·韦恩共同创立苹果电脑公司。',
          timestamp: DateTime(1976, 4, 1),
          type: EventType.biography,
          tags: ['创业', '苹果'],
          isImportant: true,
        ),
        TimelineEvent(
          id: _uuid.v4(),
          title: '推出Macintosh',
          description: '发布革命性的个人电脑Macintosh，首次采用图形用户界面。',
          timestamp: DateTime(1984, 1, 24),
          type: EventType.biography,
          tags: ['产品', '创新'],
          isImportant: true,
        ),
        TimelineEvent(
          id: _uuid.v4(),
          title: '回归苹果',
          description: '在离开苹果12年后，乔布斯重新回到苹果担任CEO。',
          timestamp: DateTime(1997, 9, 16),
          type: EventType.biography,
          tags: ['苹果', '转折'],
          isImportant: true,
        ),
        TimelineEvent(
          id: _uuid.v4(),
          title: '发布iPhone',
          description: '推出革命性的智能手机iPhone，改变了整个手机行业。',
          timestamp: DateTime(2007, 1, 9),
          type: EventType.biography,
          tags: ['产品', 'iPhone', '创新'],
          isImportant: true,
        ),
        TimelineEvent(
          id: _uuid.v4(),
          title: '逝世',
          description: '史蒂夫·乔布斯因胰腺癌逝世，享年56岁。',
          timestamp: DateTime(2011, 10, 5),
          type: EventType.biography,
          tags: ['逝世'],
          isImportant: true,
        ),
      ],
    );
  }

  /// Create movie promotion sample
  static Timeline _createMovieTimeline() {
    final now = DateTime.now();
    return Timeline(
      id: _uuid.v4(),
      name: '《阿凡达2》宣发历程',
      description: '詹姆斯·卡梅隆科幻巨制《阿凡达：水之道》的宣发时间线',
      category: EventType.movie,
      createdAt: now,
      updatedAt: now,
      events: [
        TimelineEvent(
          id: _uuid.v4(),
          title: '正式立项',
          description: '詹姆斯·卡梅隆宣布《阿凡达》续集正式立项，计划拍摄多部续集。',
          timestamp: DateTime(2013, 4, 15),
          type: EventType.movie,
          tags: ['立项'],
          isImportant: true,
        ),
        TimelineEvent(
          id: _uuid.v4(),
          title: '主要演员回归',
          description: '萨姆·沃辛顿、佐伊·索尔达娜等主要演员确认回归。',
          timestamp: DateTime(2017, 3, 10),
          type: EventType.movie,
          tags: ['演员'],
        ),
        TimelineEvent(
          id: _uuid.v4(),
          title: '水下拍摄开始',
          description: '剧组开始进行大规模的水下动作捕捉拍摄，创造了多项技术突破。',
          timestamp: DateTime(2017, 5, 20),
          type: EventType.movie,
          tags: ['拍摄', '技术'],
          isImportant: true,
        ),
        TimelineEvent(
          id: _uuid.v4(),
          title: '首支预告片',
          description: '在CinemaCon上首次公开展示预告片，反响热烈。',
          timestamp: DateTime(2022, 4, 27),
          type: EventType.movie,
          tags: ['预告', '宣发'],
          isImportant: true,
        ),
        TimelineEvent(
          id: _uuid.v4(),
          title: '全球首映',
          description: '《阿凡达：水之道》在伦敦举行全球首映礼。',
          timestamp: DateTime(2022, 12, 6),
          type: EventType.movie,
          tags: ['首映'],
          isImportant: true,
        ),
        TimelineEvent(
          id: _uuid.v4(),
          title: '全球上映',
          description: '影片在全球范围内正式上映，首周末票房创下多项纪录。',
          timestamp: DateTime(2022, 12, 16),
          type: EventType.movie,
          tags: ['上映', '票房'],
          isImportant: true,
        ),
      ],
    );
  }
}
