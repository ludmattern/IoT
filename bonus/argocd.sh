kubectl port-forward svc/argocd-server -n argocd 8080:443
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
kubectl get secret gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode ; echo







      global:
          edition: ce
          hosts:
            domain: qroyo.com
            https: false
            externalIP: 127.0.0.1
            gitlab:
              name: gitlab.qroyo.com
              https: false
            registry:
              name: registry.qroyo.com
              https: false
            minio:
              name: minio.qroyo.com
              https: false
            kas:
              name: kas.qroyo.com
              https: false
            pages:
              name: pages.qroyo.com
              https: false
            ssh: gitlab.qroyo.com
          initialRootPassword:
            secret: gitlab-initial-root-password
          kubernetes:
            inCluster: true
          grafana:
            enabled: false
          ingress:
            enabled: true
            class: "traefik"
          minio:
            enabled: false
          appConfig:
            artifacts:
              enabled: false
            lfs:
              enabled: false
            uploads:
              enabled: false
            packages:
              enabled: false
          gitaly:
            enabled: true
            persistence:
              size: 1Gi
          shell:
            port: 22
          migrationsTimeout: 1200
          time_zone: UTC
        gitlab:
          webservice:
            ingress:
              enabled: true
              annotations:
                kubernetes.io/ingress.class: "traefik"
                traefik.ingress.kubernetes.io/router.entrypoints: web
                traefik.ingress.kubernetes.io/router.tls: "true"
              tls:
                enabled: false
              hosts:
                - host: gitlab.qroyo.com
                  paths:
                    - path: /
                      pathType: Prefix
              service:
                port: 8080
          sidekiq:
            minReplicas: 1
            maxReplicas: 1
            resources:
              requests:
                cpu: 100m
                memory: 800Mi
          gitlab-shell:
            enabled: false
          kas:
            enabled: false
          toolbox:
            enabled: false
          migrations:
            enabled: true
          upgradeCheck:
          enabled: false
        nginx-ingress:
          enabled: false
        certmanager:
          install: false
        certmanager-issuer:
          enabled: false
          email: qroyo.student@42lyon.fr
        prometheus:
          install: false
        gitlab-runner:
          install: false
        registry:
          enabled: false