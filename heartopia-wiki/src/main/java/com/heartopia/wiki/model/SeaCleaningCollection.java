package com.heartopia.wiki.model;

import lombok.Data;

import java.util.Arrays;
import java.util.List;

@Data
public class SeaCleaningCollection {
    private Integer id;
    private String name;
    private Integer level;
    private String time;
    private String weather;
    private String location;
    private Integer proficiency;
    private Integer goldPrice1;
    private Integer goldPrice2;
    private Integer goldPrice3;
    private Integer goldPrice4;
    private Integer goldPrice5;
    private String imageUrl;
    private Integer sortOrder;
    private String eventName;
    private Integer masteryBeginnerMax;
    private Integer masteryIntroMin;
    private Integer masteryExpertMin;
    private Integer masteryMasterMin;

    public List<Integer> getPrices() {
        return Arrays.asList(goldPrice1, goldPrice2, goldPrice3, goldPrice4, goldPrice5);
    }

    public boolean hasMasteryData() {
        return masteryBeginnerMax != null;
    }

    public List<Integer> getMasteryRanges() {
        return Arrays.asList(masteryBeginnerMax, masteryIntroMin, masteryExpertMin, masteryMasterMin);
    }

    public String getDisplayTime() {
        if (time == null || time.isBlank()) {
            return "미공개";
        }
        String namedPeriods = time.replace(" ", "");
        if ("새벽,오후,저녁".equals(namedPeriods)) {
            return "0~6 / 12~24";
        }
        if ("새벽,오전,저녁".equals(namedPeriods)) {
            return "0~12 / 18~24";
        }
        return time
                .replace("00:00", "0")
                .replace("06:00", "6")
                .replace("12:00", "12")
                .replace("18:00", "18")
                .replace("24:00", "24");
    }
}
