// {
//   "data": [
//     {
//       "id": 12,
//       "user_id": 19,
//       "name": "",
//       "profile_image": null,
//       "rating": null,
//       "skills": [],
//       "level": 3,
//       "status": "new",
//       "is_favorited": false
//     },
//     {
//       "id": 9,
//       "user_id": 14,
//       "name": "Test5",
//       "profile_image": null,
//       "rating": null,
//       "skills": [],
//       "level": 3,
//       "status": "pending",
//       "is_favorited": false
//     },
//     {
//       "id": 7,
//       "user_id": 12,
//       "name": "test 3",
//       "profile_image": {
//         "id": 9,
//         "attachable_type": "user",
//         "attachable_id": 12,
//         "attachment_type": 1,
//         "user_id": 12,
//         "filename": "image_picker_CD1C5515-4F03-4B85-9535-64BDF58A3A92-7765-00000086FA214A0C_q80.jpg",
//         "path": "attachments/0N8qftoc1uGf3LlheqllSdAHmx15vRJUaZa77pKx.jpg",
//         "file_extension": "jpg",
//         "filesize": 336184,
//         "deleted_at": null,
//         "created_at": "2025-10-22T12:38:40.000000Z",
//         "attachment_attributes": null,
//         "url": "https://dev.justnasaa.com/storage/attachments/0N8qftoc1uGf3LlheqllSdAHmx15vRJUaZa77pKx.jpg"
//       },
//       "rating": null,
//       "skills": [],
//       "level": 3,
//       "status": "pending",
//       "is_favorited": false
//     }
//   ],
//   "links": {
//     "first": "https://dev.justnasaa.com/api/coach_featured?page=1",
//     "last": "https://dev.justnasaa.com/api/coach_featured?page=1",
//     "prev": null,
//     "next": null
//   },
//   "meta": {
//     "current_page": 1,
//     "from": 1,
//     "last_page": 1,
//     "links": [
//       {
//         "url": null,
//         "label": "&laquo; Previous",
//         "page": null,
//         "active": false
//       },
//       {
//         "url": "https://dev.justnasaa.com/api/coach_featured?page=1",
//         "label": "1",
//         "page": 1,
//         "active": true
//       },
//       {
//         "url": null,
//         "label": "Next &raquo;",
//         "page": null,
//         "active": false
//       }
//     ],
//     "path": "https://dev.justnasaa.com/api/coach_featured",
//     "per_page": 15,
//     "to": 3,
//     "total": 3
//   }
// }

import 'featured_coach_model.dart';

class FeaturedCoachesResponse {
  final List<FeaturedCoachModel>? data;
  final Links? links;
  final Meta? meta;

  FeaturedCoachesResponse({this.data, this.links, this.meta});

  factory FeaturedCoachesResponse.fromJson(Map<String, dynamic> json) {
    return FeaturedCoachesResponse(
      data: (json['data'] as List?)
          ?.map((e) => FeaturedCoachModel.fromJson(e))
          .toList(),
      links: json['links'] != null ? Links.fromJson(json['links']) : null,
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'data': data?.map((e) => e.toJson()).toList(),
    'links': links?.toJson(),
    'meta': meta?.toJson(),
  };
}

class Links {
  final String? first;
  final String? last;
  final String? prev;
  final String? next;

  Links({this.first, this.last, this.prev, this.next});

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      first: json['first'],
      last: json['last'],
      prev: json['prev'],
      next: json['next'],
    );
  }

  Map<String, dynamic> toJson() => {
    'first': first,
    'last': last,
    'prev': prev,
    'next': next,
  };
}

class Meta {
  final int? currentPage;
  final int? from;
  final int? lastPage;
  final List<PageLink>? links;
  final String? path;
  final int? perPage;
  final int? to;
  final int? total;

  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      currentPage: json['current_page'],
      from: json['from'],
      lastPage: json['last_page'],
      links: (json['links'] as List?)
          ?.map((e) => PageLink.fromJson(e))
          .toList(),
      path: json['path'],
      perPage: json['per_page'],
      to: json['to'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() => {
    'current_page': currentPage,
    'from': from,
    'last_page': lastPage,
    'links': links?.map((e) => e.toJson()).toList(),
    'path': path,
    'per_page': perPage,
    'to': to,
    'total': total,
  };
}

class PageLink {
  final String? url;
  final String? label;
  final int? page;
  final bool? active;

  PageLink({this.url, this.label, this.page, this.active});

  factory PageLink.fromJson(Map<String, dynamic> json) {
    return PageLink(
      url: json['url'],
      label: json['label'],
      page: json['page'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() => {
    'url': url,
    'label': label,
    'page': page,
    'active': active,
  };
}
