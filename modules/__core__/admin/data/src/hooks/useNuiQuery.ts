import { useCallback, useMemo, useState } from "react";

export const useNuiQuery = (namespace: string) => {
  const [loading, setLoading] = useState(false);
  const [data, setData] = useState<any>();

  // Hack to allow usage of nuiQuery in browser.
  const resourceName = useMemo(() => {
    let _resourceName = "browser";
    try {
      _resourceName = GetParentResourceName();
    } catch {}

    return _resourceName;
  }, []);

  const query = useCallback(
    (payload: unknown) => {
      setLoading(true);

      if (resourceName === "browser") {
        console.log(`[MOCK FETCH CALL] - ${namespace}`, payload);
        return new Promise<Response>((res, rej) => {
          setTimeout(() => {
            setLoading(false);
            setData({});
            res({} as Response);
          }, 1500);
        });
      }

      return fetch(`http://${resourceName}/${namespace}`, {
        method: "post",
        headers: {
          "Content-type": "application/json; charset=UTF-8",
        },
        body: JSON.stringify(payload),
      }).then((response) => {
        setLoading(false);
        setData(response);
        return response;
      });
    },
    [namespace, resourceName]
  );

  return { query, loading, data };
};
