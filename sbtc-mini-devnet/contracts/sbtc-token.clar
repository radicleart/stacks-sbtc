(impl-trait 'SP3FBR2AGK5H9QBDH3EEN6DF8EK8JY7RX8QJ5SVTE.sip-010-trait-ft-standard.sip-010-trait)

(define-constant err-unauthorised (err u401))
(define-constant err-not-token-owner (err u4))

(define-fungible-token sbtc-token)
(define-fungible-token sbtc-token-locked)

(define-data-var token-name (string-ascii 32) "sBTC Mini")
(define-data-var token-symbol (string-ascii 10) "sBTC")
(define-data-var token-uri (optional (string-utf8 256)) none)
(define-constant token-decimals u8)

(define-read-only (is-protocol-caller (who principal))
	(contract-call? .sbtc-controller is-protocol-caller contract-caller)
)

;; --- Protocol functions

;; #[allow(unchecked_data)]
(define-public (protocol-transfer (amount uint) (sender principal) (recipient principal))
	(begin
		(try! (is-protocol-caller contract-caller))
		(ft-transfer? sbtc-token amount sender recipient)
	)
)

;; #[allow(unchecked_data)]
(define-public (protocol-lock (amount uint) (owner principal))
	(begin
		(try! (is-protocol-caller contract-caller))
		(try! (ft-burn? sbtc-token amount owner))
		(ft-mint? sbtc-token-locked amount owner)
	)
)

;; #[allow(unchecked_data)]
(define-public (protocol-unlock (amount uint) (owner principal))
	(begin
		(try! (is-protocol-caller contract-caller))
		(try! (ft-burn? sbtc-token-locked amount owner))
		(ft-mint? sbtc-token amount owner)
	)
)

;; #[allow(unchecked_data)]
(define-public (protocol-mint (amount uint) (recipient principal))
	(begin
		(try! (is-protocol-caller contract-caller))
		(ft-mint? sbtc-token amount recipient)
	)
)

;; #[allow(unchecked_data)]
(define-public (protocol-burn (amount uint) (owner principal))
	(begin
		(try! (is-protocol-caller contract-caller))
		(ft-burn? sbtc-token amount owner)
	)
)

;; #[allow(unchecked_data)]
(define-public (protocol-burn-locked (amount uint) (owner principal))
	(begin
		(try! (is-protocol-caller contract-caller))
		(ft-burn? sbtc-token-locked amount owner)
	)
)

;; #[allow(unchecked_data)]
(define-public (protocol-set-name (new-name (string-ascii 32)))
	(begin
		(try! (is-protocol-caller contract-caller))
		(ok (var-set token-name new-name))
	)
)

;; #[allow(unchecked_data)]
(define-public (protocol-set-symbol (new-symbol (string-ascii 10)))
	(begin
		(try! (is-protocol-caller contract-caller))
		(ok (var-set token-symbol new-symbol))
	)
)

;; #[allow(unchecked_data)]
(define-public (protocol-set-token-uri (new-uri (optional (string-utf8 256))))
	(begin
		(try! (is-protocol-caller contract-caller))
		(ok (var-set token-uri new-uri))
	)
)

(define-private (protocol-mint-many-iter (item {amount: uint, recipient: principal}))
	(ft-mint? sbtc-token (get amount item) (get recipient item))
)

;; #[allow(unchecked_data)]
(define-public (protocol-mint-many (recipients (list 200 {amount: uint, recipient: principal})))
	(begin
		(try! (is-protocol-caller contract-caller))
		(ok (map protocol-mint-many-iter recipients))
	)
)

;; --- Public functions

;; sip-010-trait

;; #[allow(unchecked_data)]
(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
	(begin
		(asserts! (or (is-eq tx-sender sender) (is-eq contract-caller sender)) err-not-token-owner)
		(ft-transfer? sbtc-token amount sender recipient)
	)
)

(define-read-only (get-name)
	(ok (var-get token-name))
)

(define-read-only (get-symbol)
	(ok (var-get token-symbol))
)

(define-read-only (get-decimals)
	(ok token-decimals)
)

(define-read-only (get-balance (who principal))
	(ok (+ (ft-get-balance sbtc-token who) (ft-get-balance sbtc-token-locked who)))
)

(define-read-only (get-balance-locked (who principal))
	(ok (ft-get-balance sbtc-token-locked who))
)

(define-read-only (get-total-supply)
	(ok (+ (ft-get-supply sbtc-token) (ft-get-supply sbtc-token-locked)))
)

(define-read-only (get-token-uri)
	(ok (var-get token-uri))
)
