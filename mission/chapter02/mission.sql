--------------------- 1번 ---------------------
select
    um.id as user_mission_id,
    m.id as mission_id,
    s.id as store_id,
    s.name as store_name,
    m.point as mission_point,
    m.price as mission_condition_price,
    um.created_at as completed_at
from user_mission um
join mission m on um.mission_id = m.id
join store s on m.store_id = s.id
where um.user_id = 1 and um.status = 'SUCCESS'
    and um.id < 64
order by um.id DESC
limit 5;

-- 혹은 비즈니스 로직 상에서 한 사람당 미션은 
-- 5개 정도까지만으로 제한할 수도 있다고 생각
select
    um.id as user_mission_id,
    m.id as mission_id,
    s.id as store_id,
    s.name as store_name,
    m.point as mission_point,
    m.price as mission_condition_price,
    um.created_at as completed_at
from user_mission um
join mission m on um.mission_id = m.id
join store s on m.store_id = s.id
where um.user_id = 1 and um.status = 'SUCCESS'
order by um.id DESC

--------------------- 2번 ---------------------
UPDATE review
SET
    answer = '리뷰 감사합니다.',
    answered_at = NOW()
WHERE
    user_mission_id = 1
  AND deleted_at IS NULL;
-- 애초에 null 필드를 이렇게 명시적으로 검색하는 것보단
-- is_deleted를 두거나 다른 방안 생각해보면 좋을듯


--------------------- 3번 ---------------------
# 지역
SELECT l.name 
FROM user_location ul
JOIN location l ON ul.location_id = l.id
WHERE ul.user_id = :userId 
  AND ul.selected = 1;

# 포인트 합계
SELECT IFNULL(SUM(amount), 0) AS total_point
FROM point
WHERE user_id = :userId;

# 클리어한 미션 수
SELECT
    COUNT(*) AS completed_count,
    -- 총 미션 같은 경우에는 스테이지 별로 할 거면 
    -- stage 테이블이 따로 있어야 할 것 같다.
    -- 모든 스테이지가 10개 클리어시 1000p 임을 가정
FROM user_mission
WHERE user_id = 1
  AND status = 'SUCCESS'      
  AND deleted_at IS NULL;
  
# 알람
SELECT EXISTS (
    SELECT 1 -- 아무 숫자나! 존재만 하면 되니깐
    
    FROM notification n
             LEFT JOIN notification_read nr ON n.id = nr.notification_id AND nr.user_id = :userId
    WHERE n.receiver_id = :userId
      AND nr.read_at IS NULL
) AS has_unread;

SELECT 
    m.id AS cursor_id,          
    s.name AS store_name,   
    fc.name AS category_name,   
    m.price,          
    m.point,                    
    DATEDIFF(m.end_at, NOW()) AS d_day -- 디데이 
FROM mission m
JOIN store s ON m.store_id = s.id
JOIN store_category sc ON s.id = sc.store_id
JOIN food_category fc ON sc.category_id = fc.id
-- WHERE m.id < ?                  -- 커서 적용 시 주석 해제
ORDER BY m.id DESC              
LIMIT 5;


--------------------- 4번 ---------------------
SELECT 
    u.nickname,
    u.email,
    CASE 
        WHEN u.Is_phone_verified = 1 THEN '인증완료'
        ELSE '미인증'
    END AS phone_status,
    u.profile_url,
    IFNULL(SUM(p.amount), 0) AS total_point
FROM user u
LEFT JOIN point p ON u.id = p.user_id
WHERE u.id = 1 -- 현재 로그인한 유저 ID
GROUP BY u.id;


--------------------- 5번 (시니어 미션) ---------------------
# 처음 - 커서 X
SELECT 
    m.point,
    um.created_at,
    um.id AS cursor_id,    -- 클라이언트에게 넘겨줄 커서 ID
    s.name AS store_name,
    m.price
FROM user_mission um
JOIN mission m ON um.mission_id = m.id
JOIN store s ON m.store_id = s.id
WHERE um.user_id = 1 
  AND um.status = 'SUCCESS' 
ORDER BY m.point DESC, um.created_at DESC, um.id DESC
LIMIT 10;


# 두번째 - 커서 사용
SELECT 
    m.point,
    um.created_at,
    um.id AS cursor_id,
    s.name AS store_name,
    m.price
FROM user_mission um
JOIN mission m ON um.mission_id = m.id
JOIN store s ON m.store_id = s.id
WHERE um.user_id = 1 
  AND um.status = 'SUCCESS'
  AND (
      -- 포인트로 먼저 비교
      m.point < 1000 
      OR 
      -- 포인트가 같을 때 날짜로 비교
      (m.point = 1000 AND um.created_at < '2026-03-26 17:00:00')
      OR
      -- 포인트, 날짜가 같을 때 um.id로 비교
      (m.point = 1000 AND um.created_at = '2026-03-26 17:00:00' AND um.id < 45)
  )
ORDER BY m.point DESC, um.created_at DESC, um.id DESC
LIMIT 10;
