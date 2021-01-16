import { useCallback, useEffect } from "react";

/**
 *
 * @param handler event handler function
 * @param eventName eventName parameter
 * @returns emulate, calls emulate(data) to trigger fake events
 * @example
 * ```
 * const { emulate } = useNuiEvent(data => console.log(data), "eventNAMELOL");
 * ```
 */
export const useNuiEvent = <T = any>(
  handler: (data: T) => void,
  action: string
) => {
  useEffect(() => {
    const eventHandler = (event: MessageEvent<any>) => {
      const { data } = event;

      console.log(JSON.stringify(data));

      if (data.action === action) {
        handler(data);
      }
    };

    window.addEventListener("message", eventHandler);
    return () => window.removeEventListener("message", eventHandler);
  }, [handler, action]);

  const emulate = useCallback(
    (data) => {
      const messageEvent = new MessageEvent("message", {
        data: { ...data, action },
      });
      window.dispatchEvent(messageEvent);
    },
    [handler, action]
  );

  return { emulate };
};
