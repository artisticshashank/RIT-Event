-- 1. Create type for payment status if it doesn't exist
DO $$ BEGIN
    CREATE TYPE payment_status AS ENUM ('pending', 'received', 'failed', 'refunded');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- 2. Create service_transactions table
CREATE TABLE IF NOT EXISTS public.service_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    service_request_id UUID REFERENCES public.service_requests(id) ON DELETE CASCADE,
    provider_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    customer_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    agreed_amount NUMERIC(10, 2) NOT NULL DEFAULT 0.0,
    payment_status payment_status DEFAULT 'pending',
    invoice_generated BOOLEAN DEFAULT FALSE,
    completed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS for service_transactions
ALTER TABLE public.service_transactions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own transactions"
ON public.service_transactions FOR SELECT
USING (auth.uid() = provider_id OR auth.uid() = customer_id);

CREATE POLICY "Providers can update transactions"
ON public.service_transactions FOR UPDATE
USING (auth.uid() = provider_id);

CREATE POLICY "System can insert transactions"
ON public.service_transactions FOR INSERT
WITH CHECK (true);

-- 3. Create or Update spare_parts table
CREATE TABLE IF NOT EXISTS public.spare_parts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    seller_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    price NUMERIC(10, 2) NOT NULL DEFAULT 0.0,
    stock_quantity INT DEFAULT 0,
    sku TEXT,
    icon_code TEXT DEFAULT 'parts',
    image_url TEXT,
    category TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS for spare_parts
ALTER TABLE public.spare_parts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view spare_parts"
ON public.spare_parts FOR SELECT
USING (true);

CREATE POLICY "Sellers can manage their own spare_parts"
ON public.spare_parts FOR ALL
USING (auth.uid() = seller_id);

-- 4. Create trigger to automatically complete service_requests and mark invoice_generated
CREATE OR REPLACE FUNCTION handle_payment_received()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.payment_status = 'received' AND OLD.payment_status != 'received' THEN
    NEW.invoice_generated := TRUE;
    NEW.completed_at := NOW();
    
    -- Also update the service request to completed
    UPDATE public.service_requests
    SET status = 'completed',
        updated_at = NOW()
    WHERE id = NEW.service_request_id;
  END IF;
  
  -- Update updated_at timestamp
  NEW.updated_at := NOW();
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop trigger if exists to prevent duplicates
DROP TRIGGER IF EXISTS on_payment_received ON public.service_transactions;

-- Create the trigger
CREATE TRIGGER on_payment_received
  BEFORE UPDATE ON public.service_transactions
  FOR EACH ROW EXECUTE FUNCTION handle_payment_received();
