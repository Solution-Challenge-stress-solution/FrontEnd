class DiaryEntry {
  final int diaryId;
  final String content;
  final String audioFileUrl;
  final double angry;
  final double sadness;
  final double disgusting;
  final double fear;
  final double happiness;
  final double stressPoint;
  final String maxEmotion;
  final int activityId;

  DiaryEntry({
    required this.diaryId,
    required this.content,
    required this.audioFileUrl,
    required this.angry,
    required this.sadness,
    required this.disgusting,
    required this.fear,
    required this.happiness,
    required this.stressPoint,
    required this.maxEmotion,
    required this.activityId,
  });

  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(
      diaryId: json['diaryId'],
      content: json['content'],
      audioFileUrl: json['audioFileUrl'],
      angry: json['angry'],
      sadness: json['sadness'],
      disgusting: json['disgusting'],
      fear: json['fear'],
      happiness: json['happiness'],
      stressPoint: json['stress_point'],
      maxEmotion: json['max_emotion'],
      activityId: json['activityId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'diaryId': diaryId,
      'content': content,
      'audioFileUrl': audioFileUrl,
      'angry': angry,
      'sadness': sadness,
      'disgusting': disgusting,
      'fear': fear,
      'happiness': happiness,
      'stress_point': stressPoint,
      'max_emotion': maxEmotion,
      'activityId': activityId,
    };
  }
}
