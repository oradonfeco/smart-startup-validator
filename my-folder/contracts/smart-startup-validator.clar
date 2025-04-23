(define-constant FEE-USDV u100) ;; optional fee of 1 USDV per validation

(define-data-var validation-counter uint u0)

(define-map validations
  { id: uint }
  {
    submitter: principal,
    idea-title: (string-utf8 100),
    status: (string-ascii 10), ;; "go" or "no-go"
    competitors: uint,
    market-size: uint,
    pitchdeck-url: (string-utf8 200)
  }
)

(define-public (submit-validation
    (idea-title (string-utf8 100))
    (status (string-ascii 10))
    (competitors uint)
    (market-size uint)
    (pitchdeck-url (string-utf8 200))
)
  (begin
    ;; Charge the user (optional)
    ;; (try! (ft-transfer? usd-asset-contract tx-sender contract-principal FEE-USDV))

    (let ((id (+ (var-get validation-counter) u1)))
      (map-set validations
        { id: id }
        {
          submitter: tx-sender,
          idea-title: idea-title,
          status: status,
          competitors: competitors,
          market-size: market-size,
          pitchdeck-url: pitchdeck-url
        }
      )
      (var-set validation-counter id)
      (ok id)
    )
  )
)

(define-read-only (get-validation (id uint))
  (map-get? validations { id: id })
)

(define-read-only (get-total-validations)
  (ok (var-get validation-counter))
)
