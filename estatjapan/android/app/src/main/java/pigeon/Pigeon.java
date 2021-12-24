// Autogenerated from Pigeon (v1.0.7), do not edit directly.
// See also: https://pub.dev/packages/pigeon

package pigeon;

import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.common.StandardMessageCodec;
import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

/** Generated class from Pigeon. */
@SuppressWarnings({"unused", "unchecked", "CodeBlock2Expr", "RedundantSuppression"})
public class Pigeon {

  /** Generated class from Pigeon that represents data sent in messages. */
  public static class PurchaseModel {
    private Boolean isPurchase;
    public Boolean getIsPurchase() { return isPurchase; }
    public void setIsPurchase(Boolean setterArg) { this.isPurchase = setterArg; }

    private Boolean isUsedTrial;
    public Boolean getIsUsedTrial() { return isUsedTrial; }
    public void setIsUsedTrial(Boolean setterArg) { this.isUsedTrial = setterArg; }

    Map<String, Object> toMap() {
      Map<String, Object> toMapResult = new HashMap<>();
      toMapResult.put("isPurchase", isPurchase);
      toMapResult.put("isUsedTrial", isUsedTrial);
      return toMapResult;
    }
    static PurchaseModel fromMap(Map<String, Object> map) {
      PurchaseModel fromMapResult = new PurchaseModel();
      Object isPurchase = map.get("isPurchase");
      fromMapResult.isPurchase = (Boolean)isPurchase;
      Object isUsedTrial = map.get("isUsedTrial");
      fromMapResult.isUsedTrial = (Boolean)isUsedTrial;
      return fromMapResult;
    }
  }
  private static class HostPurchaseModelApiCodec extends StandardMessageCodec {
    public static final HostPurchaseModelApiCodec INSTANCE = new HostPurchaseModelApiCodec();
    private HostPurchaseModelApiCodec() {}
    @Override
    protected Object readValueOfType(byte type, ByteBuffer buffer) {
      switch (type) {
        case (byte)128:         
          return PurchaseModel.fromMap((Map<String, Object>) readValue(buffer));
        
        default:        
          return super.readValueOfType(type, buffer);
        
      }
    }
    @Override
    protected void writeValue(ByteArrayOutputStream stream, Object value)     {
      if (value instanceof PurchaseModel) {
        stream.write(128);
        writeValue(stream, ((PurchaseModel) value).toMap());
      } else 
{
        super.writeValue(stream, value);
      }
    }
  }

  /** Generated interface from Pigeon that represents a handler of messages from Flutter.*/
  public interface HostPurchaseModelApi {
    PurchaseModel getPurchaseModel();
    Boolean getIsUsedTrial();
    Boolean requestPurchaseModel();
    Boolean restorePurchaseModel();

    /** The codec used by HostPurchaseModelApi. */
    static MessageCodec<Object> getCodec() {
      return HostPurchaseModelApiCodec.INSTANCE;
    }

    /** Sets up an instance of `HostPurchaseModelApi` to handle messages through the `binaryMessenger`. */
    static void setup(BinaryMessenger binaryMessenger, HostPurchaseModelApi api) {
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.HostPurchaseModelApi.getPurchaseModel", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              PurchaseModel output = api.getPurchaseModel();
              wrapped.put("result", output);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.HostPurchaseModelApi.getIsUsedTrial", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              Boolean output = api.getIsUsedTrial();
              wrapped.put("result", output);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.HostPurchaseModelApi.requestPurchaseModel", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              Boolean output = api.requestPurchaseModel();
              wrapped.put("result", output);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.HostPurchaseModelApi.restorePurchaseModel", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              Boolean output = api.restorePurchaseModel();
              wrapped.put("result", output);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
    }
  }
  private static class FlutterPurchaseModelApiCodec extends StandardMessageCodec {
    public static final FlutterPurchaseModelApiCodec INSTANCE = new FlutterPurchaseModelApiCodec();
    private FlutterPurchaseModelApiCodec() {}
    @Override
    protected Object readValueOfType(byte type, ByteBuffer buffer) {
      switch (type) {
        case (byte)128:         
          return PurchaseModel.fromMap((Map<String, Object>) readValue(buffer));
        
        default:        
          return super.readValueOfType(type, buffer);
        
      }
    }
    @Override
    protected void writeValue(ByteArrayOutputStream stream, Object value)     {
      if (value instanceof PurchaseModel) {
        stream.write(128);
        writeValue(stream, ((PurchaseModel) value).toMap());
      } else 
{
        super.writeValue(stream, value);
      }
    }
  }

  /** Generated class from Pigeon that represents Flutter messages that can be called from Java.*/
  public static class FlutterPurchaseModelApi {
    private final BinaryMessenger binaryMessenger;
    public FlutterPurchaseModelApi(BinaryMessenger argBinaryMessenger){
      this.binaryMessenger = argBinaryMessenger;
    }
    public interface Reply<T> {
      void reply(T reply);
    }
    static MessageCodec<Object> getCodec() {
      return FlutterPurchaseModelApiCodec.INSTANCE;
    }

    public void sendPurchaseModel(PurchaseModel purchaseModelArg, Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.FlutterPurchaseModelApi.sendPurchaseModel", getCodec());
      channel.send(new ArrayList<Object>(Arrays.asList(purchaseModelArg)), channelReply -> {
        callback.reply(null);
      });
    }
  }
  private static Map<String, Object> wrapError(Throwable exception) {
    Map<String, Object> errorMap = new HashMap<>();
    errorMap.put("message", exception.toString());
    errorMap.put("code", exception.getClass().getSimpleName());
    errorMap.put("details", null);
    return errorMap;
  }
}
