package cards

import (
	"github.com/stripe/stripe-go/v72"
	"github.com/stripe/stripe-go/v72/paymentintent"
)

type Card struct {
	Secret   string
	Key      string
	Currency string
}

type Transaction struct {
	TransactionStatus int
	Amount            int
	Currency          string
	LastFour          string
	BankReturnCode    string
}

func (c *Card) Charge(currency string, amount int) (*stripe.PaymentIntent, string, error) {
	return c.CreatePaymentIntent(currency, amount)
}

func (c *Card) CreatePaymentIntent(currency string, amount int) (*stripe.PaymentIntent, string, error) {
	stripe.Key = c.Secret

	// create a payment intent
	params := &stripe.PaymentIntentParams{
		Amount:   stripe.Int64(int64(amount)),
		Currency: stripe.String(c.Currency),
	}

	pi, err := paymentintent.New(params)
	if err != nil {
		msg := ""
		if stripeErr, ok := err.(*stripe.Error); ok {
			msg = cardErrorMessage(stripeErr.Code)
		}
		return nil, msg, err
	}
	return pi, "", nil
}

func cardErrorMessage(code stripe.ErrorCode) string {
	var msg = ""
	switch code {
	case stripe.ErrorCodeCardDeclined:
		msg = "Your card was declined."
	case stripe.ErrorCodeExpiredCard:
		msg = "Your card is expired."
	case stripe.ErrorCodeAmountTooLarge:
		msg = "Your card has insufficient funds."
	case stripe.ErrorCodeProcessingError:
		msg = "There was an error processing your card."
	case stripe.ErrorCodeIncorrectCVC:
		msg = "Your card's security code is incorrect."
	case stripe.ErrorCodeIncorrectZip:
		msg = "Your card's zip code failed validation."
	case stripe.ErrorCodeAmountTooSmall:
		msg = "Your card's minimum payment is $5."
	case stripe.ErrorCodeBalanceInsufficient:
		msg = "Your card has insufficient funds."
	case stripe.ErrorCodePostalCodeInvalid:
		msg = "Your card's zip code failed validation."
	default:
		msg = "There was an error processing your payment."
	}
	return msg
}
