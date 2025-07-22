/**
 * らーめん太郎公式サイト - スクロールアニメーション
 * 和風らしい控えめなアニメーション効果を実装
 */

document.addEventListener('DOMContentLoaded', function() {
    // スクロールアニメーションの初期化
    initScrollAnimation();
    
    // スムーズスクロールの実装（古いブラウザ対応）
    initSmoothScroll();
});

/**
 * スクロールアニメーションの初期化
 */
function initScrollAnimation() {
    // Intersection Observer API対応チェック
    if (!('IntersectionObserver' in window)) {
        // 古いブラウザの場合はフォールバック
        fallbackAnimation();
        return;
    }

    // アニメーション対象要素を取得
    const animationTargets = document.querySelectorAll('.fade-in');
    
    if (animationTargets.length === 0) {
        return;
    }

    // Intersection Observerのオプション設定
    const observerOptions = {
        root: null,
        rootMargin: '0px 0px -100px 0px', // 少し早めにトリガー
        threshold: 0.3 // 30%表示されたときにアニメーション開始
    };

    // Observer作成
    const observer = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                // 要素が表示範囲に入った場合
                const target = entry.target;
                
                // 遅延アニメーションで和風らしい控えめな演出
                setTimeout(() => {
                    target.classList.add('active');
                }, Math.random() * 200); // 0-200msのランダム遅延
                
                // 一度アニメーションした要素は監視を停止（パフォーマンス向上）
                observer.unobserve(target);
            }
        });
    }, observerOptions);

    // 各要素を監視対象に追加
    animationTargets.forEach(target => {
        observer.observe(target);
    });
}

/**
 * 古いブラウザ向けフォールバック
 */
function fallbackAnimation() {
    let ticking = false;
    
    function updateAnimations() {
        const animationTargets = document.querySelectorAll('.fade-in:not(.active)');
        const windowHeight = window.innerHeight;
        
        animationTargets.forEach(target => {
            const elementTop = target.getBoundingClientRect().top;
            
            if (elementTop < windowHeight * 0.8) {
                target.classList.add('active');
            }
        });
        
        ticking = false;
    }
    
    function requestUpdateAnimations() {
        if (!ticking) {
            requestAnimationFrame(updateAnimations);
            ticking = true;
        }
    }
    
    // 初期チェック
    updateAnimations();
    
    // スクロール時のイベントリスナー
    window.addEventListener('scroll', requestUpdateAnimations, { passive: true });
}

/**
 * スムーズスクロールの実装
 */
function initSmoothScroll() {
    // CSS scroll-behaviorをサポートしていない古いブラウザ用
    if (!CSS.supports('scroll-behavior', 'smooth')) {
        const links = document.querySelectorAll('a[href^="#"]');
        
        links.forEach(link => {
            link.addEventListener('click', function(e) {
                const targetId = this.getAttribute('href').slice(1);
                const targetElement = document.getElementById(targetId);
                
                if (targetElement) {
                    e.preventDefault();
                    
                    const targetPosition = targetElement.getBoundingClientRect().top + window.pageYOffset;
                    
                    window.scrollTo({
                        top: targetPosition,
                        behavior: 'smooth'
                    });
                }
            });
        });
    }
}

/**
 * パフォーマンス監視とデバッグ用（開発時のみ使用）
 */
if (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1') {
    // 開発環境でのみ実行
    console.log('🍜 らーめん太郎公式サイト - 開発モード');
    
    // パフォーマンス計測
    window.addEventListener('load', function() {
        const loadTime = performance.now();
        console.log(`⏱️ ページ読み込み時間: ${Math.round(loadTime)}ms`);
    });
}

/**
 * ギャラリー画像の遅延読み込み（将来の拡張用）
 */
function initLazyLoading() {
    if ('loading' in HTMLImageElement.prototype) {
        // ネイティブ lazy loading サポート
        const images = document.querySelectorAll('img[loading="lazy"]');
        images.forEach(img => {
            img.src = img.dataset.src;
        });
    } else {
        // Intersection Observer による lazy loading
        const imageObserver = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const img = entry.target;
                    img.src = img.dataset.src;
                    img.classList.remove('lazy');
                    imageObserver.unobserve(img);
                }
            });
        });

        const lazyImages = document.querySelectorAll('img[data-src]');
        lazyImages.forEach(img => imageObserver.observe(img));
    }
}

/**
 * アクセシビリティ向上のための設定
 */
function initAccessibility() {
    // ユーザーがモーション減少を希望している場合の対応
    if (window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
        // アニメーションを無効化
        const style = document.createElement('style');
        style.innerHTML = `
            .fade-in {
                opacity: 1 !important;
                transform: none !important;
                transition: none !important;
            }
        `;
        document.head.appendChild(style);
    }
}

// アクセシビリティ設定の初期化
initAccessibility();