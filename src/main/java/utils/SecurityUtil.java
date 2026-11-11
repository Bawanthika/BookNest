package utils;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

public final class SecurityUtil {
    private SecurityUtil() {}
    public static String hashPassword(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] encoded = digest.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder hex = new StringBuilder();
            for (byte b : encoded) hex.append(String.format("%02x", b));
            return hex.toString();
        } catch (Exception e) { throw new IllegalStateException("Unable to hash password", e); }
    }
}
