package com.crazecoder.openfile.utils;

import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONArray;

import java.util.Map;

/**
 * Note of this class.
 *
 * @author crazecoder
 * @since 2018/12/28
 */
public class JsonUtil {
    public static String toJson(Map<String, Object> map) {
        JSONObject jsonObject = new JSONObject();
        try {
            for (Map.Entry<String, Object> entry : map.entrySet()) {
                jsonObject.put(entry.getKey(), entry.getValue());
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return jsonObject.toString();
    }
    /**
     * Convert a List of Objects (Map or primitives) to JSON array string.
     * If elements are Map<String, Object>, they will be converted to JSONObject.
     */
    public static String listToJson(java.util.List<?> list) {
        JSONArray jsonArray = new JSONArray();
        try {
            if (list != null) {
                for (Object item : list) {
                    if (item instanceof Map) {
                        JSONObject obj = new JSONObject();
                        @SuppressWarnings("unchecked")
                        Map<String, Object> map = (Map<String, Object>) item;
                        for (Map.Entry<String, Object> entry : map.entrySet()) {
                            obj.put(entry.getKey(), entry.getValue());
                        }
                        jsonArray.put(obj);
                    } else {
                        jsonArray.put(item);
                    }
                }
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return jsonArray.toString();
    }
}
