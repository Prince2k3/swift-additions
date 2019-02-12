import Foundation
import CoreGraphics

protocol Currency {
    var decimalValue: Decimal { get } // maintain precision
}

extension Currency {
    func currency(_ fractDigits: Int = 0, locale: Locale = .current) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = fractDigits
        return formatter.string(for: self.decimalValue) ?? "$0.00"
    }
}

extension Double: Currency {
    var decimalValue: Decimal {
        return Decimal(self)
    }
}

extension Int: Currency {
    var decimalValue: Decimal {
        return Decimal(self)
    }
}

extension String: Currency {
    var decimalValue: Decimal {
        return Decimal(string: self) ?? 0
    }
}

extension CGFloat: Currency {
    var decimalValue: Decimal {
        return Decimal(Double(self))
    }
}
