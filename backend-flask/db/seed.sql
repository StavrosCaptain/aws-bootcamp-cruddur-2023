-- this file was manually created
INSERT INTO public.users (display_name, email, handle, cognito_user_id)
VALUES
  ('Andrew Brown', 'stavrstavr17@gmail.com', 'andrewbrown' ,'MOCK'),
  ('Andrew Bayko', 'stavrstavr16@yahoo.gr', 'bayko' ,'MOCK');
  ('Stavros Stavrinos', 'stavrstavr17@yahoo.gr', 'stavrosstavrinos' ,'MOCK');
  --('Andreas Stavrinos', 'stavrstavr16@yahoo.gr', 'andreasstavrinos', 'MOCK')

INSERT INTO public.activities (user_uuid, message, expires_at)
VALUES
  (
    (SELECT uuid from public.users WHERE users.handle = 'andrewbrown' LIMIT 1),
    'This was imported as seed data!',
    current_timestamp + interval '10 day'
  )