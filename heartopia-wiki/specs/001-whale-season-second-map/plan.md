# Implementation Plan: Whale Season Second Map

## Context

- Spec: `specs/001-whale-season-second-map/spec.md`
- Current codebase notes:
  - `map.html` already has a `mapKey` switch.
  - `map-state.js` already filters non-default maps by `item.mapKey`.
  - `MapPin` and `MapPinMapper` do not yet include `map_key`.
  - `forageable.html` already has an event select backed by `WikiFilter`.

## Approach

Add `mapKey` to map pin and zone models/mappers/APIs, remove the temporary second-map placement block, and attach active map key to save requests. Add whale season forageable SQL/assets and a quick event filter button.

## Impacted Files

- `src/main/java/com/heartopia/wiki/model/MapPin.java`: add `mapKey`.
- `src/main/java/com/heartopia/wiki/model/LocationZone.java`: add `mapKey`.
- `src/main/java/com/heartopia/wiki/mapper/MapPinMapper.java`: map-key query methods.
- `src/main/resources/mapper/MapPinMapper.xml`: `map_key` select/insert/update filters.
- `src/main/java/com/heartopia/wiki/mapper/LocationZoneMapper.java`: map-key query/update methods.
- `src/main/resources/mapper/LocationZoneMapper.xml`: `map_key` result and filters.
- `src/main/java/com/heartopia/wiki/controller/MapController.java`: accept `mapKey` request params and default to `town`.
- `src/main/resources/static/js/map/*.js`: include `mapKey` in save/fetch and allow second-map placement.
- `src/main/resources/templates/wiki/collections/forageable.html`: quick whale filter.
- `src/main/resources/sql/20260711_whale_season_second_map.sql`: DB migration and seed data.
- `src/main/resources/static/images/collections/forage/*`: whale forageable images.

## Data Model

- `map_pins.map_key` separates pin records by map.
- `location_zones.map_key` prepares separate zone records by map.
- `forageable_collections.event_name` marks whale season items.

## API Or Interface Changes

- `GET /wiki/map/api/pins?mapKey=second`
- `POST /wiki/map/api/pins` accepts `mapKey` in JSON.
- `GET /wiki/map/api/zones?mapKey=second`
- `PUT /wiki/map/api/zones/{zoneKey}/position` accepts `mapKey` in JSON.

## Validation And Error Handling

- Missing or blank `mapKey` defaults to `town`.
- Writes keep existing admin-only security boundary.

## Test Plan

- Run JavaScript syntax checks for changed map files.
- Run `gradlew test`.
- Manually inspect diffs and verify SQL follow-up requirements.

## Risks And Mitigations

- DB not migrated: provide explicit SQL path and expected verification query.
- Existing first-map data hidden accidentally: SQL defaults existing rows to `town`, and app defaults missing key to `town`.

## Alternatives Considered

- Frontend-only filtering: rejected because admin pin persistence would still mix map data in one table.

## Plan Checklist

- [x] Spec의 모든 요구사항이 구현 접근에 매핑되어 있다.
- [x] 영향 파일이 구체적이다.
- [x] 테스트 방법이 있다.
- [x] 과설계 가능성이 검토되었다.
- [x] 미확정 사항이 남아 있으면 구현 전에 확인하도록 표시되어 있다.
